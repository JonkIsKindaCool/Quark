package;

import quark.app.App;
import lime.app.Application;

class Main extends Application {
	override function onWindowCreate() {
		super.onWindowCreate();

		App.run(new Game());
	}
}
