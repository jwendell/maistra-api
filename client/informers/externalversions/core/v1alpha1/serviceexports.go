// Copyright Red Hat, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Code generated by main. DO NOT EDIT.

package v1alpha1

import (
	"context"
	time "time"

	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	runtime "k8s.io/apimachinery/pkg/runtime"
	watch "k8s.io/apimachinery/pkg/watch"
	cache "k8s.io/client-go/tools/cache"
	internalinterfaces "maistra.io/api/client/informers/externalversions/internalinterfaces"
	v1alpha1 "maistra.io/api/client/listers/core/v1alpha1"
	versioned "maistra.io/api/client/versioned"
	corev1alpha1 "maistra.io/api/core/v1alpha1"
)

// ServiceExportsInformer provides access to a shared informer and lister for
// ServiceExportses.
type ServiceExportsInformer interface {
	Informer() cache.SharedIndexInformer
	Lister() v1alpha1.ServiceExportsLister
}

type serviceExportsInformer struct {
	factory          internalinterfaces.SharedInformerFactory
	tweakListOptions internalinterfaces.TweakListOptionsFunc
	namespace        string
}

// NewServiceExportsInformer constructs a new informer for ServiceExports type.
// Always prefer using an informer factory to get a shared informer instead of getting an independent
// one. This reduces memory footprint and number of connections to the server.
func NewServiceExportsInformer(client versioned.Interface, namespace string, resyncPeriod time.Duration, indexers cache.Indexers) cache.SharedIndexInformer {
	return NewFilteredServiceExportsInformer(client, namespace, resyncPeriod, indexers, nil)
}

// NewFilteredServiceExportsInformer constructs a new informer for ServiceExports type.
// Always prefer using an informer factory to get a shared informer instead of getting an independent
// one. This reduces memory footprint and number of connections to the server.
func NewFilteredServiceExportsInformer(client versioned.Interface, namespace string, resyncPeriod time.Duration, indexers cache.Indexers, tweakListOptions internalinterfaces.TweakListOptionsFunc) cache.SharedIndexInformer {
	return cache.NewSharedIndexInformer(
		&cache.ListWatch{
			ListFunc: func(options v1.ListOptions) (runtime.Object, error) {
				if tweakListOptions != nil {
					tweakListOptions(&options)
				}
				return client.CoreV1alpha1().ServiceExportses(namespace).List(context.TODO(), options)
			},
			WatchFunc: func(options v1.ListOptions) (watch.Interface, error) {
				if tweakListOptions != nil {
					tweakListOptions(&options)
				}
				return client.CoreV1alpha1().ServiceExportses(namespace).Watch(context.TODO(), options)
			},
		},
		&corev1alpha1.ServiceExports{},
		resyncPeriod,
		indexers,
	)
}

func (f *serviceExportsInformer) defaultInformer(client versioned.Interface, resyncPeriod time.Duration) cache.SharedIndexInformer {
	return NewFilteredServiceExportsInformer(client, f.namespace, resyncPeriod, cache.Indexers{cache.NamespaceIndex: cache.MetaNamespaceIndexFunc}, f.tweakListOptions)
}

func (f *serviceExportsInformer) Informer() cache.SharedIndexInformer {
	return f.factory.InformerFor(&corev1alpha1.ServiceExports{}, f.defaultInformer)
}

func (f *serviceExportsInformer) Lister() v1alpha1.ServiceExportsLister {
	return v1alpha1.NewServiceExportsLister(f.Informer().GetIndexer())
}