%%--------------------------------------------------------------------
%% Copyright (c) 2016-2017 EMQ Enterprise, Inc. (http://emqtt.io)
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(emqx_hw_coap_server).

-include("emqx_hw_coap.hrl").

-export([start/0, start/1, stop/0]).

-define(LOG(Level, Format, Args),
    lager:Level("CoAP: " ++ Format, Args)).

start() ->
    start(application:get_env(?APP, port, 5683)).

start(Port) ->
    application:start(lwm2m_coap),
    lwm2m_coap_server:start_udp(lwm2m_udp_socket, Port),

    CertFile = application:get_env(?APP, certfile, ""),
    KeyFile = application:get_env(?APP, keyfile, ""),
    case (filelib:is_regular(CertFile) andalso filelib:is_regular(KeyFile)) of
        true ->
            lwm2m_coap_server:start_dtls(lwm2m_dtls_socket, [{certfile, CertFile}, {keyfile, KeyFile}]);
        false ->
            ?LOG(error, "certfile ~p or keyfile ~p are not valid, turn off coap DTLS", [CertFile, KeyFile])
    end,
    lwm2m_coap_server_registry:add_handler([<<"mqtt">>], emq_hw_coap_resource, undefined),
    lwm2m_coap_server_registry:add_handler([<<"t">>], emq_hw_coap_resource, undefined).

stop() ->
    application:stop(lwm2m_coap).

