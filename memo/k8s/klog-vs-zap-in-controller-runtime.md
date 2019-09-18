# Klog

It's human-readable format (maybe).

```
akihito@TPX280:~/go/src/example.org/metrics-server-operator$ make run
/home/akihito/go/bin/controller-gen object:headerFile=./hack/boilerplate.go.txt paths="./..."
go fmt ./...
go vet ./...
/home/akihito/go/bin/controller-gen "crd:trivialVersions=true" rbac:roleName=manager-role webhook paths="./..." output:crd:artifacts:config=config/crd/bases
go run ./main.go
I0919 06:38:24.355114   21089 listener.go:40] controller-runtime/metrics "level"=0 "msg"="metrics server is starting to listen"  "addr"=":8080"
I0919 06:38:24.356615   21089 controller.go:121] controller-runtime/controller "level"=0 "msg"="Starting EventSource"  "controller"="metricsserver-controller" "source"={"Type":{"metadata":{"creationTimestamp":null},"spec":{},"status":{"healthy":false}}}
I0919 06:38:24.611295   21089 controller.go:121] controller-runtime/controller "level"=0 "msg"="Starting EventSource"  "controller"="metricsserver-controller" "source"=
I0919 06:38:24.611445   21089 main.go:79] setup "level"=0 "msg"="starting manager"  
I0919 06:38:24.611694   21089 internal.go:245] controller-runtime/manager "level"=0 "msg"="starting metrics server"  "path"="/metrics"
I0919 06:38:24.712656   21089 controller.go:134] controller-runtime/controller "level"=0 "msg"="Starting Controller"  "controller"="metricsserver-controller"
I0919 06:38:24.813259   21089 controller.go:154] controller-runtime/controller "level"=0 "msg"="Starting workers"  "controller"="metricsserver-controller" "worker count"=1



^CMakefile:26: recipe for target 'run' failed
make: *** [run] Error 1
```

# Zap

It's more machine-readble format.

```
/home/akihito/go/bin/controller-gen "crd:trivialVersions=true" rbac:roleName=manager-role webhook paths="./..." output:crd:artifacts:config=config/crd/bases
go run ./main.go
2019-09-19T06:40:33.820+0900	INFO	controller-runtime.metrics	metrics server is starting to listen	{"addr": ":8080"}
2019-09-19T06:40:33.821+0900	INFO	controller-runtime.controller	Starting EventSource	{"controller": "metricsserver-controller", "source": "kind source: /, Kind="}
2019-09-19T06:40:34.076+0900	INFO	controller-runtime.controller	Starting EventSource	{"controller": "metricsserver-controller", "source": "channel source: 0xc0000f4960"}
2019-09-19T06:40:34.076+0900	INFO	setup	starting manager
2019-09-19T06:40:34.077+0900	INFO	controller-runtime.manager	starting metrics server	{"path": "/metrics"}
2019-09-19T06:40:34.177+0900	INFO	controller-runtime.controller	Starting Controller	{"controller": "metricsserver-controller"}
2019-09-19T06:40:34.278+0900	INFO	controller-runtime.controller	Starting workers	{"controller": "metricsserver-controller", "worker count": 1}
^CMakefile:26: recipe for target 'run' failed
make: *** [run] Error 1
```
