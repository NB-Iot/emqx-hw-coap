PROJECT = emqx_hw_coap
PROJECT_DESCRIPTION = CoAP Gateway for Huawei NB-Iot module
PROJECT_VERSION = 2.3

DEPS = lager lwm2m_coap clique
dep_lager    = git https://github.com/basho/lager
dep_lwm2m_coap = git https://github.com/grutabow/lwm2m-coap
dep_clique   = git https://github.com/emqtt/clique

BUILD_DEPS = emqx cuttlefish
dep_emqx = git git@github.com:emqx/emqx.git
dep_cuttlefish = git https://github.com/emqtt/cuttlefish

ERLC_OPTS += +debug_info
ERLC_OPTS += +'{parse_transform, lager_transform}'
TEST_ERLC_OPTS += +'{parse_transform, lager_transform}'

include erlang.mk

app.config::
	./deps/cuttlefish/cuttlefish -l info -e etc/ -c etc/emqx_hw_coap.conf -i priv/emqx_hw_coap.schema -d data
