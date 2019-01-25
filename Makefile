SHELL = /bin/bash
NS = release-monitoring
TMPL_PATH = openshift-template.yaml
TMPL_LABEL = release-monitoring
REG = docker.io
ORG = odranoel
ANITYA_IMAGE = anitya
ANITYA_TAG = latest
DB_URL = sqlite:////opt/anitya/data/anitya-dev.sqlite
GH_CLIENT_ID = defineme
GH_CLIENT_SECRET = defineme

image/anitya/build:
	@cd anitya && docker build -t ${REG}/${ORG}/${ANITYA_IMAGE}:${ANITYA_TAG} .

image/anitya/push:
	@docker push ${REG}/${ORG}/${ANITYA_IMAGE}:${ANITYA_TAG}

openshift/deploy/postgre:
	@oc new-app -f postgre/${TMPL_PATH} -n ${NS}

openshift/deploy/anitya:
	@oc new-app -f anitya/${TMPL_PATH} -n ${NS} -p 'DB_URL=${DB_URL}' -p 'GITHUB_OAUTH_KEY=${GH_CLIENT_ID}' -p 'GITHUB_OAUTH_SECRET=${GH_CLIENT_SECRET}'

openshift/delete:
	@oc delete all -l template=${TMPL_LABEL} -n ${NS}
	@oc delete pvc/postgresql-data -n ${NS}
	@oc delete secret/postgresql -n ${NS}

#postgresql://userDEF:a5HOfpREfbXxEuI1@postgresql.anitya.svc:5432/integreatly