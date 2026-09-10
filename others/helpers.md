O comando abaixo ajuda a entender o retorno da flag -s (parse config and dump state and exit) do LMAPD, auxiliando a entender o que é necessário ter no controller para usar o PUT.

Comandos:
```bash
./build/src/lmapd \
    -j \
    -s \
    -b lab/capabilities \
    -c lab/config/config.json \
    -q lab/queue \
    -r lab/run
```
Saída:

{
  "ietf-lmap-control:lmap":{
    "capabilities":{
      "version":"simet-lmapd version 0.15.7",
      "tag":[
        "system-ipv4-capable",
        "system-ipv6-capable"
      ],
      "tasks":{
        "task":[
          {
            "name":"hello-world",
            "program":"\/home\/joao-medicoes-laptop\/Documentos\/nic.br\/orquestracao-medicoes-lmap-controller\/poc-simet-lmapd\/simet-lmapd\/lab\/bin\/measurement\/hello-world.sh"
          },
          {
            "name":"long-task",
            "program":"\/home\/joao-medicoes-laptop\/Documentos\/nic.br\/orquestracao-medicoes-lmap-controller\/poc-simet-lmapd\/simet-lmapd\/lab\/bin\/measurement\/long-task.sh"
          }
        ]
      }
    },
    "tasks":{
      "task":[
        {
          "name":"hello-world",
          "program":"\/home\/joao-medicoes-laptop\/Documentos\/nic.br\/orquestracao-medicoes-lmap-controller\/poc-simet-lmapd\/simet-lmapd\/lab\/bin\/measurement\/hello-world.sh"
        }
      ]
    },
    "schedules":{
      "schedule":[
        {
          "name":"hello-schedule",
          "start":"every-10-seconds",
          "execution-mode":"sequential",
          "state":"enabled",
          "storage":"0",
          "invocations":0,
          "suppressions":0,
          "overlaps":0,
          "failures":0,
          "action":[
            {
              "name":"run-hello-10s",
              "task":"hello-world",
              "state":"enabled",
              "storage":"0",
              "invocations":0,
              "suppressions":0,
              "overlaps":0,
              "failures":0
            }
          ]
        }
      ]
    },
    "events":{
      "event":[
        {
          "name":"every-10-seconds",
          "periodic":{
            "interval":10,
            "start":"2026-09-03T10:30:00-03:00"
          }
        }
      ]
    }
  }
}lmapd: /home/joao-medicoes-laptop/Documentos/nic.br/orquestracao-medicoes-lmap-controller/poc-simet-lmapd/simet-lmapd/src/pidfile.c:49: lmapd_pid_read: Assertion `lmapd && lmapd->run_path' failed.
Abortado

Podemos, de forma breve, separar em o retorno em:

capabilities
├── version do simet-lmapd
├── tags detectadas pelo MA
└── Tasks que o MA é capaz de executar

configuração/Instruction aplicada
├── Tasks configuradas
├── Events
└── Schedules / Actions

estado operacional
├── enabled
├── invocations
├── suppressions
├── overlaps
└── failures