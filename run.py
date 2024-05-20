import melee
import time

dolphin_path = "/opt/slippi-extracted/AppRun"
iso_path = "/opt/melee/Melee.iso"

console = melee.Console(
    path=dolphin_path,
    tmp_home_directory=True,
    copy_home_directory=True,
    setup_gecko_codes=True,
    fullscreen=False,
    disable_audio=True
)

controller_1 = melee.Controller(console=console, port=1, type=melee.ControllerType.STANDARD)
controller_2 = melee.Controller(console=console, port=2, type=melee.ControllerType.STANDARD)

console.run(iso_path=iso_path)
console.connect()

controller_1.connect()
controller_2.connect()

while True:
    gamestate = console.step()
    if gamestate.menu_state in [melee.Menu.IN_GAME, melee.Menu.SUDDEN_DEATH]:
        with open('/opt/melee/test.txt', 'a') as fd:
            fd.write(f'{gamestate.frame}')
    else:
        melee.MenuHelper.menu_helper_simple(gamestate,
                                            controller_1,
                                            melee.Character.FOX,
                                            melee.Stage.YOSHIS_STORY,
                                            '',
                                            autostart=True,
                                            swag=False)
        melee.MenuHelper.menu_helper_simple(gamestate,
                                            controller_2,
                                            melee.Character.FOX,
                                            melee.Stage.YOSHIS_STORY,
                                            '',
                                            autostart=True,
                                            swag=False)

console.stop()

