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

-module(emqx_hw_coap_app).

-behaviour(application).

-include("emqx_hw_coap.hrl").

-export([start/2, stop/1, prep_stop/1]).

start(_Type, _Args) ->
    {ok, Sup} = emqx_hw_coap_sup:start_link(),
    emqx_hw_coap_server:start(application:get_env(?APP, port_hw, 5683)),
    emqx_hw_coap_config:register(),
    {ok,Sup}.

prep_stop(State) ->
	emqx_hw_coap_config:unregister(),
    State.

stop(_State) ->
    spawn(
      fun() ->
          group_leader(whereis(init), self()),
          emqx_hw_coap_server:stop()
      end).

