#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os

import pytoml as toml

#loads toml cfg file
cfg_path = os.environ['ANITYA_WEB_CONFIG']
with open(cfg_path) as f:
    data = toml.load(f)

#(ENV KEY, CFG KEY) name mapping
keys = [
    ('DB_URL', 'db_url'),
    ('SECRET_KEY', 'secret_key'),
    ('GITHUB_ACCESS_TOKEN' ,'github_access_token'),
    ('SOCIAL_AUTH_GITHUB_KEY', 'social_auth_github_key'),
    ('SOCIAL_AUTH_GITHUB_SECRET', 'social_auth_github_secret')
]
#replaces config value with env value if env var is set
for env_key, cfg_key in keys:
    env_value = os.environ.get(env_key)
    if env_value:
        data[cfg_key] = env_value

#writes new config file
with open(cfg_path, 'w+') as f:
    f.write(toml.dumps(data))

#fix alembic.ini file
with open('/opt/anitya/alembic.ini', 'r') as f:
    alembic_content = f.read()
    alembic_content = alembic_content.replace('__DB_REPLACE_ME__', data['db_url'])

with open('/opt/anitya/alembic.ini', 'w+') as f:
    f.write(alembic_content)
