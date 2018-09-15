local k8s = import 'k8s.jsonnet';

local appcm = k8s.configmap(
  namespace='testkit',
  name='appcm',
  deployment='app',
  withoutVersion=true,
  data={
    __THIS_IS_APP__: 'YES',
  },
);

local cmscm = k8s.configmap(
  namespace='testkit',
  name='cmscm',
  deployment='cms',
  withoutVersion=true,
  data={
    __THIS_IS_CMS__: 'YES',
  },
);

local app = k8s.image_to_url(
  namespace='testkit',
  name='app',
  host='app.testkit.local',
  image='sunfmin/testkit',
  configmap='appcm',
);

local cms = k8s.image_to_url(
  namespace='testkit',
  name='cms',
  host='cms.testkit.local',
  image='sunfmin/testkit',
  configmap='cmscm',
);

local ing = k8s.ingress(
  namespace='testkit',
  name='entry',
  rules=[
    {
      host: 'www.testkit.local',
      http: {
        paths: [
          {
            path: '/cms',
            backend: {
              serviceName: 'cms',
              servicePort: 4000,
            },
          },
          {
            path: '/.+',
            backend: {
              serviceName: 'app',
              servicePort: 4000,
            },
          },
          {
            path: '/',
            backend: {
              serviceName: 'cms',
              servicePort: 4000,
            },
          },
        ],
      },
    },
  ],
  annotations={
    'nginx.ingress.kubernetes.io/configuration-snippet': |||
      proxy_set_header x-cms-production 1;
    |||,
  },
);


k8s.list([
  appcm,
  cmscm,
  app,
  cms,
  ing,
])
