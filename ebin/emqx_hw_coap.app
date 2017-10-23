{application, emqx_hw_coap, [
	{description, "CoAP Gateway for Huawei NB-Iot module"},
	{vsn, "2.3"},
	{modules, ['emqx_hw_coap_app','emqx_hw_coap_config','emqx_hw_coap_mqtt_adapter','emqx_hw_coap_registry','emqx_hw_coap_resource','emqx_hw_coap_server','emqx_hw_coap_sup','emqx_hw_coap_timer']},
	{registered, [emqx_hw_coap_sup]},
	{applications, [kernel,stdlib,lager,lwm2m_coap,clique]},
	{mod, {emqx_hw_coap_app, []}}
]}.