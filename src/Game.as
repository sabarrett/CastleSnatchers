package
{
	import flash.events.Event;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	
	/**
	 * ...
	 * @author Scott Barrett
	 */
	public class Game extends World
	{
		private var health:int;
		private var castle:Castle;
		private var renegades:Array;
		private var healthUI:Text;
		private var spawner:RefugeeSpawner;
		private var harpoon:Harpoon;
		
		public function Game()
		{
			castle = new Castle();
			castle.setBase(0, FP.height - 100);
			castle.layer = 0;
			add(castle);
			
			renegades = new Array();
			var ren1:Escaper = new Escaper();
			ren1.x = castle.right - ren1.width;
			ren1.y = castle.bottom - ren1.height;
			ren1.addEventListener(Escaper.EXIT_SCREEN_EVENT, onPeasantExit);
			add(ren1);
			renegades.push(ren1);
			
			spawner = new RefugeeSpawner(castle.right - ren1.width, castle.bottom - ren1.height);
			spawner.addRenegade = addRenegade;
			add(spawner);
			
			Escaper.changeHealth = changeHealth;
			
			health = 100;
			healthUI = new Text(health.toString());
			healthUI.x = FP.width - healthUI.textWidth;
			healthUI.y = 0;
			addGraphic(healthUI);
			
			harpoon = new Harpoon();
			harpoon.x = castle.right - harpoon.width - 21; // account for flag's width
			harpoon.y = castle.bottom - harpoon.height;
			harpoon.layer = 1;
			add(harpoon);
			
			harpoon.setStartX(harpoon.x);
			harpoon.startY = harpoon.y;
		}
		
		override public function render():void 
		{
			healthUI.text = health.toString();
			healthUI.x = FP.width - healthUI.textWidth;
			
			super.render();
		}
		
		public function changeHealth(dec:int):void
		{
			health -= dec;
		}
		
		public function addRenegade(x:Number, y:Number):Escaper
		{
			var newGuy:Escaper = new Escaper(x, y);
			add(newGuy);
			renegades.push(newGuy);
			newGuy.addEventListener(Escaper.EXIT_SCREEN_EVENT, onPeasantExit);
			return renegades[0];
		}
		
		private function onPeasantExit(e:Event):void 
		{
			changeHealth(5);
		}
	}

}