local k8s = import 'k8s.jsonnet';

local k1cm = k8s.configmap(
    namespace = "testkit",
    name = "k1cm",
    deployment = "kit1",
    withoutVersion = true,
    data = {
        "__THIS_IS_KIT11111__": "YES",
    },
);

local k2cm = k8s.configmap(
    namespace = "testkit",
    name = "k2cm",
    deployment = "kit2",
    withoutVersion = true,
    data = {
        "__THIS_IS_KIT22222__": "YES",
    },
);

local kit1 = k8s.image_to_url(
    namespace = "testkit",
    name = "kit1",
    host = "kit1.testkit.local",
    image = "sunfmin/testkit",
    configmap = "k1cm",
);

local kit2 = k8s.image_to_url(
    namespace = "testkit",
    name = "kit2",
    host = "kit2.testkit.local",
    image = "sunfmin/testkit",
    configmap = "k2cm",
);

local ing = k8s.ingress(
    namespace = "testkit",
    name = "entry",
    rules = [
        {
            host: "www.testkit.local",
            http: {
                paths: [
                    {
                        path: '/kit1',
                        backend: {
                            serviceName: 'kit1',
                            servicePort: 4000,
                        },
                    },
                    {
                        path: '/',
                        backend: {
                            serviceName: 'kit2',
                            servicePort: 4000,
                        },
                    },
                ],
            },
        },
    ],
);


k8s.list([
    k1cm,
    k2cm,
    kit1,
    kit2,
    ing,
])
