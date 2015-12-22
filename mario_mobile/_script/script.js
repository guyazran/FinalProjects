// JavaScript Document

var game_width;
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

var arrow_left;
var arrow_right;
var arrow_up;

$(document).ready(function(){

	//prevent right click
	window.oncontextmenu = function noRightClick (e){
	  return false;
	};

	// $(document).doubletap(function(e){
	// 	e.preventDefault;
	// }, function(e){
	// 	//single tap
	// });

	$(document).nodoubletapzoom();

	//remove delay from touch
	if (window.Touch) {
  		$('.arrow').bind('touchstart', function(e) {
    		e.preventDefault();
  		});
  		$('.arrow').bind('touchend', function(e) {
    		e.preventDefault();
    		return $(this).trigger('click');
  		});
	}

	arrow_left = document.getElementById("arrow_left");
	arrow_up = document.getElementById("arrow_up");
	arrow_right = document.getElementById("arrow_right");

	arrow_left.addEventListener('touchstart', function(e){
        left = true;
    }, false);
    arrow_left.addEventListener('touchend', function(e){
        left = false;
    }, false);
    arrow_up.addEventListener('touchstart', function(e){
        up = true;
    }, false);
    arrow_up.addEventListener('touchend', function(e){
        up = false;
    }, false);
    arrow_right.addEventListener('touchstart', function(e){
        right = true;
    }, false);
    arrow_right.addEventListener('touchend', function(e){
        right = false;
    }, false);

	mario1 = document.getElementById("mario");
	mario_x = mario1.offsetLeft;
	mario_y = mario1.offsetTop;
	enemy1 = document.getElementById("enemy");
	enemy_x = enemy1.offsetLeft;
	enemy_y = enemy1.offsetTop;
	coin1 = document.getElementById("coin");
	game_width = document.getElementById("game").offsetWidth;
	setCoin();
	score1 = 0;
	lives1 = 5;
	jumping = false;
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
	if(mario_x+100>game_width)
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
	if(window.innerHeight > window.innerWidth){
    	alert("Please use Landscape!");
	}

	game_width = document.getElementById("game").offsetWidth;

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
	if(enemy_x>game_width - 50)
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
		coin1.style.left = Math.floor((Math.random() * 1000) + 1)+"px";
		coin_x = coin1.offsetLeft;
	}
	while(coin_x<5 || coin_x>game_width - 60);
	do
	{
		coin1.style.top = Math.floor((Math.random() * 1000) + 1)+"px";
		coin_y = coin1.offsetTop;
	}
	while(coin_y<120 || coin_y>284);
	
	if(coin_x>mario_x-10 && coin_x<mario_x+70 && coin_y<mario_y+100 && coin_y>mario_y-30)
		{
			setCoin();
		}
}

function flash()
{
	if(hit)
	{
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
	enemy_x = 20;
	enemy1.style.left = mario_x + "px";
	lives1 = 5;
	document.getElementById("lives").innerHTML=lives1;	
}

//jquery plugin for determiining double taps to prevent double tap to zoom
(function($) {
  $.fn.nodoubletapzoom = function() {
      $(this).bind('touchstart', function preventZoom(e) {
        var t2 = e.timeStamp
          , t1 = $(this).data('lastTouch') || t2
          , dt = t2 - t1
          , fingers = e.originalEvent.touches.length;
        $(this).data('lastTouch', t2);
        if (!dt || dt > 500 || fingers > 1) return; // not double-tap

        e.preventDefault(); // double tap - prevent the zoom
        // also synthesize click events we just swallowed up
        $(this).trigger('click').trigger('click');
      });
  };
})(jQuery);