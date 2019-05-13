%% @author zankhana
%% @doc @todo Add description to calling.


-module(calling).

%% ====================================================================
%% API functions
%% ====================================================================
-export([callToReceiver/4]).


%% ====================================================================
%% Internal functions
%% ====================================================================

%% This method will call from startMasterProcess method of exchange.erl file
callToReceiver(Sender_Name,Receiver_List,Master_Pid,Counter)->
   
    if
        Counter == 0 ->
	            timer:sleep(500),
	            lists:foreach(
	
								fun(Receiver_Tuple) -> whereis(Receiver_Tuple)!{Sender_Name,intro,element(3,now())} 
										end, Receiver_List
	
							),
					callToReceiver(Sender_Name,Receiver_List, Master_Pid, Counter + 1);
        Counter > 0 ->
	            receive
		                {Current_Process,intro,Timestamp} -> 
							Master_Pid!{intro_Message,Sender_Name,Current_Process,Timestamp},
		                    whereis(Current_Process)!{Sender_Name,reply,Timestamp},
		                    callToReceiver(Sender_Name,Receiver_List, Master_Pid, Counter + 1);
		
		                {Current_Process,reply,Timestamp} ->  
							Master_Pid!{reply_Message,Sender_Name,Current_Process,Timestamp},
		                    callToReceiver(Sender_Name,Receiver_List, Master_Pid, Counter + 1)
	            after
	                1000->
						io:fwrite("Process ~p has received no calls for 1 second, ending...~n",[Sender_Name])

	            end

    end.
