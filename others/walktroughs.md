# Alguns passo a passo para testar coisas

Projetos utilizados:
- [Este presente](https://github.com/JoaoPauloVC/poc-simet-lmapd)
- [poc-simet-lmapd](https://github.com/JoaoPauloVC/lmap_controller)

## Enviar config nova para o MA

### Ter um MA "de pé"

1) No projeto do ma (simet-lmapd), ter um lmapd ativo. A partir da raiz do projeto, rodar:

```bash
./build/src/lmapd \
  -j \
  -b lab/capabilities \
  -c lab/config/config.json \
  -q lab/queue \
  -r lab/run
```

2) É útil acompanhar os logs que são produzidos pelos scripts de teste. Para isso, em outro terminal:

```bash
tail -f /lab/logs/*
```

3) Precisamos do servidor do Controller (este projeto) também esteja rodando. Em um terceiro terminal, na raiz deste projeto, rode:

```bash
mix phx.server
```

4) Com tudo rodando, podemos fazer o teste de atualização (manual) da MA, que fará uma requisição para o Controller. Para tal, em um terminal, rode o script de fetch-instructions do projeto simet-lmapd, localizado em lab/bin/control/fetch-instuction.sh

Após este procedimento, é esperado que o arquivo em priv/data/desired-schedule.json deste projeto tenha sido enviado como config nova para o simet-lmapd.

## Pegar estado atual de uma MA

1) É necessário ter o status gerado pelo LMAPD em algum lugar. Para gerar um status do LMAPD, rode o seguinte comando, na raiz do projeto do LMAPD:


```bash
./build/src/lmapd \
  -j \
  -s \
  -b lab/capabilities \
  -c lab/config/config.json \
  -q lab/queue \
  -r lab/run \
  > /tmp/reported-state.json
```

2) Em um terminal, rode um curl para o endpoint que irá pegar o reported-state.json:

```bash
curl -i \
    -X PUT \
    -H "Content-Type: application/json" \
     --data-binary @/tmp/reported-state.json \
     http://localhost:4000/v1/agents/test-ma/state
```

No momento que isso está sendo escrito, é espero que o terminal em que foi dado o comando curl receba um HTTP/1.1 204 No Content.

3) Para conferir se o Controller recebeu os dados e cadastrou o MA no database, usamos

```bash
iex -S mix

alias LmapController.Repo
alias LmapController.Agents.MeasurementAgent

Repo.all(MeasurementAgent)
```

O esperado é ver uma lista com os elementos (MAs) cadastrados.

## Após algumas atualizações no fetch-instruction

Fetch-instruction.sh do projeto simet-lmapd foi atualizado para executar no boot. Com o projeto rodando, executamos

```bash
bash -x lab/bin/control/fetch-instruction.sh
```