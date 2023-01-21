function create()
{
	trace("create");
}

function postCreate()
{
	trace("postCreate");
}

var dontRepit:Bool = false;
var dontRepitt:Bool = false;

function update(elapsed)
{
	if (dontRepit == false)
	{
		dontRepit = true;
		trace("update");
	}
}

function postUpdate(elapsed)
{
	if (dontRepitt == false)
	{
		dontRepitt = true;
		trace("postUpdate");
	}
}

function onPlayerHit(note)
{
	trace("PALYHIY");
}

function onCpuHit(note)
{
	trace("CPUHIY");
}

function beatHit(curBeat)
{
}

function stepHit(curStep)
{
}
