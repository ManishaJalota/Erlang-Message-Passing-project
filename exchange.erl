%% @author zankhana
%% @doc @todo Add description to exchange.


-module(exchange).

%% ====================================================================
%% API functions
%% ====================================================================

-export([print_Intro_And_Reply_Message/1, start/0]).

%% ====================================================================
%% Internal functions
%% ====================================================================

%% Entry point of the exchange.erl file
start() ->

   	FileData = file:consult("/Users/ashishpatel/eclipse-workspace/Test/src/calls.txt"),
	Calling_List = element(2,FileData),

	io:format("~n** Calls to be made **~n~n",[]),
	lists:foreach( fun(Tuple)->
						{Sender,Receiver_List} = Tuple,
						io:format("~w: ~w ~n",[Sender,Receiver_List]),
						Process_Id = spawn(calling,callToReceiver,[Sender,Receiver_List,self(),0]),
						register(Sender,Process_Id)
					end,Calling_List
				 ),

	io:format("~n",[]),

	print_Intro_And_Reply_Message(0).


%% This method will print all the incoming message from callToReceiver's method
print_Intro_And_Reply_Message(Counter)->
    receive
		{intro_Message,Sender,Receiver,Timestamp} ->
            io:fwrite("~p received intro message from ~p [~p]~n",[Sender,Receiver,Timestamp]),
            print_Intro_And_Reply_Message(Counter+1);
		{reply_Message,Sender,Receiver,Timestamp} ->
            io:fwrite("~p received reply message from ~p [~p]~n",[Sender,Receiver,Timestamp]),
            print_Intro_And_Reply_Message(Counter+1)
    after
        1500->
            io:fwrite("Master has received no replies for 1.5 seconds, ending...\n",[])
    end.
