module maistra.io/api

go 1.15

require (
	github.com/ghodss/yaml v1.0.1-0.20190212211648-25d852aebe32
	github.com/maistra/istio-operator v0.0.0-00010101000000-000000000000
	k8s.io/api v0.19.10
	k8s.io/apimachinery v0.19.10
	k8s.io/client-go v12.0.0+incompatible
	sigs.k8s.io/controller-runtime v0.7.2
	sigs.k8s.io/yaml v1.2.0

)

replace github.com/maistra/istio-operator => /home/jwendell/src/maistra/istio-operator

replace k8s.io/client-go => k8s.io/client-go v0.19.10
