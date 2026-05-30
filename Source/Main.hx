package;

import quark.app.App;
import lime.app.Application;

class Main extends Application {
	public function new() {
		super();
	}

	override function onWindowCreate() {
		super.onWindowCreate();

		App.run(new Game());
	}
}