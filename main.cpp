#include <stdio.h>
#include <allegro5/allegro.h>

extern "C" int cieniowanie(int zx, int zy, int mapa[300][300]);

int main() {
    int i,j,k;
    int zx=20; // srodek bitmapy
    int zy=30; // srodek bitmapy
    int mapa[300][300];
    for(i=0; i<300; i++) {
        for(j=0; j<300; j++) {
            mapa[i][j]=255;
        }
    } // 3*300=900 255 255 255-kolor biały

    al_init();
    al_install_keyboard();
    ALLEGRO_DISPLAY* okno=al_create_display(300,300);
    if(!okno) {
        printf("ERROR\n");
        return -1;
    }
    al_set_window_title(okno,"Cieniowanie Gourauda");
    ALLEGRO_KEYBOARD_STATE key;
    al_get_keyboard_state(&key);
    cieniowanie(zx,zy,mapa);
    while(!al_key_down(&key, ALLEGRO_KEY_ESCAPE)) {
        for(i=0; i<300; i++) {
            /*k=0;
            for(j=0; j<=897 && k<900; k++) {
                al_draw_pixel(k, i, al_map_rgb(mapa[i][j], mapa[i][j+1], mapa[i][j+2]));
                j=j+3;
            }*/
            for(j=0; j<300; j++) {
                al_draw_pixel(j,i,al_map_rgb(mapa[i][j], mapa[i][j], mapa[i][j]));
            }
        }
        al_flip_display();
        al_get_keyboard_state(&key);
    }
    al_destroy_display(okno);
    return 0;
}
