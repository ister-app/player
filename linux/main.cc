#include "my_application.h"

int main(int argc, char** argv) {
  // GTK sends the program name as the Wayland app_id (and X11 WM_CLASS), and
  // KDE finds the icon through the desktop file with that name. Left alone it
  // is the binary name ("player", or "ister" in the flatpak), which matches no
  // desktop file. APPLICATION_ID stays lower-case: it names the data directory.
  g_set_prgname("app.ister.Player");
  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
