// JavaScript Document

var mario1;
var mario_x;
var mario_y;
var coin1;
var coin_x;
var coin_y;
var enemy1;
var enemy_x;
var enemy_y;
var jumping;
var elevation;
var score1;
var lives1;
var right;
var left;
var up;
var enemyDir;
var hit;
var visible;
var flashTimer;

$(document).ready(function(){
	right = false;
	left = false;
    $(document).keydown(function(e){
		switch (e.which)
		{
			case 65:
			  left = true;
			  break;
			case 68:
			  right = true;
			  break;
			case 87:
				up = true;
				break;
		}
	});
	$(document).keyup(function(e){
		switch (e.which)
		{
			case 65:
			  left = false;
			  break;
			case 68:
			  right = false;
			  break;
			  case 87:
				up = false;
				break;
		}
	});
	mario1 = document.getElementById("mario");
	mario_x = mario1.offsetLeft;
	mario_y = mario1.offsetTop;
	enemy1 = document.getElementById("enemy");
	enemy_x = enemy1.offsetLeft;
	enemy_y = enemy1.offsetTop;
	coin1 = document.getElementById("coin");
	setCoin();
	score1 = 0;
	lives1 = 5;
	jumpoing = false;
	elevation = 0;
	enemyDir = true;
	hit = false;
	visible = true;
	flashTimer = [];
	setInterval(move, 1);
	setInterval(enemyMove, 5);
	setInterval(checkMario, 1);
	setInterval(flash,250);
});

$(window).load(function(){alert("Start Game")});

function move()
{
	if(mario_x+5<0)
	{
		left = false;
	}
	if(mario_x+100>900)
	{
		right = false;
	}
	if(right)
	{
		mario_x++;
		mario1.style.left = mario_x + "px";
		mario1.style.transform = "scaleX(-1)";
	}
	if(left)
	{
		mario_x--;
		mario1.style.left = mario_x + "px";
		mario1.style.transform = "scaleX(1)";
	}
	if(up)
	{
		if(!jumping)
		{
			jumping = true;
			$("#mario_pic").attr("src","_images/mario_jump.png")
			ascend();
		}
	}
}

function ascend()
{
	if(elevation<100)
	{
		mario_y--;
		mario1.style.top = mario_y + "px";
		elevation++;
		setTimeout(ascend, 1);
	}
	else
	{
		descend();
	}
}

function descend()
{
	if(elevation>0)
	{
		mario_y++;
		mario1.style.top = mario_y + "px";
		elevation--;
		setTimeout(descend, 1);
	}
	else
	{
		jumping = false;
		$("#mario_pic").attr("src","_images/mario.png")
	}
	
}

function enemyMove()
{
	if(enemyDir)
	{
		enemy_x--;
		enemy1.style.left = enemy_x + "px";
		enemy1.style.transform = "scaleX(1)";
	}
	else
	{
		enemy_x++;
		enemy1.style.left = enemy_x + "px";
		enemy1.style.transform = "scaleX(-1)";
	}
	if(enemy_x<0)
	{
		enemyDir = false;
	}
	if(enemy_x>847)
	{
		enemyDir = true;
	}
}

function checkMario()
{
	if(coin_x>mario_x-10 && coin_x<mario_x+70 && coin_y<mario_y+100 && coin_y>mario_y-30)
		{
			score1+=100;
			document.getElementById("score").innerHTML=score1;
			if(score1 == 1000)
			{
				alert("You Win");
				resetGame();
			}
			setCoin();
		}
	if(enemy_x>mario_x-15 && enemy_x<mario_x+65 && enemy_y<mario_y+85 && enemy_y>mario_y-30)
	{
		if(!hit)
		{
			hit = true;
			lives1--;
			document.getElementById("lives").innerHTML=lives1;
			flash();
			setTimeout(function(){
				hit = false
			},2000);
			mario
			if(lives1==0)
			{
				mario1.style.display = "block";
				alert("You Lose");
				resetGame();
			}
		}
	}
}

function setCoin()
{
	do
	{
		coin1.style.left = Math.floor((Math.random() * 1000) + 1)+"px"; //5-850
		coin_x = coin1.offsetLeft;
	}
	while(coin_x<5 || coin_x>850);
	do
	{
		coin1.style.top = Math.floor((Math.random() * 1000) + 1)+"px"; //5-850
		coin_y = coin1.offsetTop;
	}
	while(coin_y<200 || coin_y>369);
	
	if(coin_x>mario_x-10 && coin_x<mario_x+70 && coin_y<mario_y+100 && coin_y>mario_y-30)
		{
			setCoin();
		}
}

function flash()
{
	if(hit)
	{
		console.log(flashTimer);
		if(visible)
		{
			visible = false;
			mario1.style.display = "none";
		}
		else
		{
			visible = true;
			mario1.style.display = "block";
		}
	}
	else
	{
		mario1.style.display = "block";
	}
}

function resetGame()
{
	score1=0;
	document.getElementById("score").innerHTML=score1;
	up=false;
	left=false;
	right=false;
	mario_x = 400;
	mario1.style.left = mario_x + "px";
	enemy_x = 847;
	enemy1.style.left = mario_x + "px";
	lives1 = 5;
	document.getElementById("lives").innerHTML=lives1;	
}