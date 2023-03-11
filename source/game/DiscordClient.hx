package game;

import Sys.sleep;
import dependency.Logs;
import discord_rpc.DiscordRpc;

using StringTools;

class DiscordClient
{
	static var _id:String = "1061291748988571709";
	static var _largeText:String = "FNF' Null Engine!";
	static var _largeImage:String = "icon";

	static var logColor:Int = Logs.CYAN;

	public function new()
	{
		Logs.log("Discord Client starting...", logColor);
		DiscordRpc.start({
			clientID: _id,
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		Logs.log("Discord Client started.", logColor);

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
		}

		DiscordRpc.shutdown();
	}

	public static function shutdown()
	{
		DiscordRpc.shutdown();
	}

	static function onReady()
	{
		DiscordRpc.presence({
			details: "In the Menus",
			state: null,
			largeImageKey: _largeImage,
			largeImageText: _largeText
		});
	}

	static function onError(_code:Int, _message:String)
	{
		Logs.error('Error! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		Logs.log('Disconnected! $_code : $_message', logColor);
	}

	public static function initialize()
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
		Logs.log('Discord Client initialized', logColor);
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float)
	{
		var startTimestamp:Float = if (hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: _largeImage,
			largeImageText: _largeText,
			smallImageKey: smallImageKey,
			startTimestamp: Std.int(startTimestamp / 1000),
			endTimestamp: Std.int(endTimestamp / 1000)
		});
	}
}
