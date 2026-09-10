defmodule LmapController.AgentsTest do
  use LmapController.DataCase, async: true

  alias LmapController.Agents
  alias LmapController.Agents.MeasurementAgent

  describe "update_reported_state/2" do
    setup do
      %{agent_id: "test-ma", reported_state: %{"status" => "initial"}}
    end

    test "creates a measurement agent (MA) when it does not exist", %{
      agent_id: agent_id,
      reported_state: reported_state
    } do
      result = Agents.update_reported_state(agent_id, reported_state)

      assert {:ok, %MeasurementAgent{} = measurement_agent} = result
      assert measurement_agent.agent_id == agent_id
      assert measurement_agent.reported_state == reported_state
      assert measurement_agent.last_seen_at != nil
    end

    test "updates an existing measurement agent (MA)", %{
      agent_id: agent_id,
      reported_state: reported_state
    } do
      updated_state = %{"status" => "updated"}

      # Generates new MeasurementAgent on table, so we can test the update of an existing MA
      {:ok, %MeasurementAgent{} = measurement_agent} =
        Agents.update_reported_state(agent_id, reported_state)

      original_id = measurement_agent.id
      original_last_seen_at = measurement_agent.last_seen_at

      # Updates MeasurementAgent with new updated_state
      {:ok, %MeasurementAgent{} = updated_measurement_agent} =
        Agents.update_reported_state(agent_id, updated_state)

      assert updated_measurement_agent.id == original_id
      assert updated_measurement_agent.agent_id == agent_id
      assert updated_measurement_agent.reported_state == updated_state
      assert updated_measurement_agent.last_seen_at >= original_last_seen_at
    end
  end

  describe "update_desired_config/2" do
    setup do
      agent_id = "test-ma"
      desired_config = %{"status" => "desired_config_to_push_to_MA"}

      {:ok, measurement_agent} =
        Agents.update_reported_state(
          agent_id,
          %{"status" => "initial"}
        )

      %{
        agent_id: agent_id,
        desired_config: desired_config,
        measurement_agent: measurement_agent
      }
    end

    test "stores the desired configuration for an existing measurement agent (MA)", %{
      agent_id: agent_id,
      measurement_agent: measurement_agent,
      desired_config: desired_config
    } do
      result = Agents.update_desired_config(agent_id, desired_config)
      assert {:ok, %MeasurementAgent{} = updated_measurement_agent} = result
      assert updated_measurement_agent.id == measurement_agent.id
      assert updated_measurement_agent.desired_config == desired_config
    end

    test "returns error when the measurement agent (MA) does not exist", %{
      desired_config: desired_config
    } do
      result = Agents.update_desired_config("unknown-ma", desired_config)

      assert {:error, :agent_not_found} = result
    end
  end
end
