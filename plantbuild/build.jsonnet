local c = import 'dc.jsonnet';
local dc = c {
  dockerRegistry: '',
};

dc.build_apps_image('sunfmin/sunfmin', [
  'testkit',
])
