#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Diam0ndz"
#define PLUGIN_VERSION "0.1"

#define PREFIX " \x02[\x01GFP\x02] \x02"

#include <sourcemod>
#include <sdktools>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "Generally Fun Purpose",
	author = PLUGIN_AUTHOR,
	description = "Very general purpose plugin. Fun stuff like !dice, !coinflip, etc.",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/Diam0ndz"
};

public void OnPluginStart()
{
	PrintToServer("Generally Fun Purpose plugin started");
	
	RegConsoleCmd("sm_dice", Action_Dice, "Rolls a dice with the specified number of sides.");
	RegConsoleCmd("sm_coinflip", Action_CoinFlip, "Flips a coin. Heads or Tails.");
	RegConsoleCmd("sm_rps", Action_RPS, "Rock Paper Scissors.");
	RegConsoleCmd("sm_rock", Action_Rock, "Choose Rock in Rock Paper Scissors.");
	RegConsoleCmd("sm_paper", Action_Paper, "Choose Paper in Rock Paper Scissors.");
	RegConsoleCmd("sm_scissors", Action_Scissors, "Choose Scissors in Rock Paper Scissors.");
}

public Action Action_Dice(int client, int args)
{
	char arg[128];
	GetCmdArgString(arg, sizeof(arg));
	int maxNum = StringToInt(arg, 10);
	if(maxNum == 0)
	{
		int rolled = GetRandomInt(1, 6);
		PrintToChatAll("%s %i", PREFIX, rolled);
		return Plugin_Handled;
	}
	int rolled = GetRandomInt(1, maxNum);
	PrintToChatAll("%s %i", PREFIX, rolled);
	return Plugin_Handled;
}

public Action Action_CoinFlip(int client, int args)
{
	int coin = GetRandomInt(0, 1);
	char result[128];
	switch(coin)
	{
		case 1:result = "Heads";
		case 2:result = "Tails";
	}
	PrintToChatAll("%s %s", PREFIX, result);
	return Plugin_Handled;
}

public Action Action_RPS(int client, int args)
{
	char arg[128];
	GetCmdArgString(arg, sizeof(arg));
	int playChoice;
	if(StrEqual(arg, "r", false) || StrEqual(arg, "rock", false))
	{
		playChoice = 0;
	}
	else if(StrEqual(arg, "p", false) || StrEqual(arg, "paper", false))
	{
		playChoice = 1;
	}
	else if(StrEqual(arg, "s", false) || StrEqual(arg, "scissors", false))
	{
		playChoice = 2;
	}
	else
	{
		PrintToChat(client, "%s Your arguments were invalid. Please use <r|p|s|rock|paper|scissors>.", PREFIX);
		return Plugin_Handled;
	}
	RPS(client, playChoice);
	return Plugin_Handled;
}

public Action RPS(int client, int choice)
{
	int comChoice = GetRandomInt(0, 2);
	if(comChoice == 0)
	{
		if(choice == 1)
		{
			PrintToChat(client, "%s I chose rock. You won!", PREFIX);
		}
		else
		{
			PrintToChat(client, "%s I chose rock. I won!", PREFIX);
		}
	}
	else if(comChoice == 1)
	{
		if(choice == 2)
		{
			PrintToChat(client, "%s I chose paper. You won!", PREFIX);
		}
		else
		{
			PrintToChat(client, "%s I chose paper. I won!", PREFIX);
		}
	}
	else if(comChoice == 2)
	{
		if(choice == 0)
		{
			PrintToChat(client, "%s I chose scissors. You won!", PREFIX);
		}
		else
		{
			PrintToChat(client, "%s I chose scissors. I won!", PREFIX);
		}
	}
	else
	{
		PrintToChat(client, "Something went wrong! Please try again.", PREFIX);
	}
}

public Action Action_Rock(int client, int args)
{
	RPS(client, 0);
	return Plugin_Handled;
}

public Action Action_Paper(int client, int args)
{
	RPS(client, 1);
	return Plugin_Handled;
}

public Action Action_Scissors(int client, int args)
{
	RPS(client, 2);
	return Plugin_Handled;
}

public bool IsValidClient(int client)
{
	if(IsClientConnected(client))
	{
		if(IsClientAuthorized(client))
		{
			if(IsClientInGame(client))
			{
				if(!IsFakeClient(client))
				{
					return true;
				}
			}
		}
	}
	return false;
}