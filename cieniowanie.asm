[bits 64]

section .data
A dd 10, 12, 255
B dd 100, 20, 255
C dd 50, 70, 255
P dd 0, 0, 0
S dd 0, 0, 0
E dd 0, 0, 0
Pcalk dd 0
Ecalk dd 0
Z dd 100.0

dx1 dd 0.0
dx2 dd 0.0
dx3 dd 0.0
dk1 dd 0.0
dk2 dd 0.0
dk3 dd 0.0
dk  dd 0.0

tmp dd 0.0, 0.0
radiany dd 57.29577951
polowa dd 45.0
prosty dd 90.0
bialy dd 255.0
zero dd 0.0
jeden dd 1.0

kolumna dd 1200
wiersz dd 300
plusplus dd 1
integer dd 4


section .text
 
global cieniowanie
 
cieniowanie:
	push rbp 	 ; tworzymy ramkê stosu
	mov rbp, rsp      ; niech RBP ma teraz warto¶æ RSP

.punktA: 
	mov rax, rdi ; rdi=zx wspolrzedna x zrodla swiatla
	mov rbx, rsi ; rsi=zy wspolrzedna y zrodla swiatla
	
	sub eax, [dword A] ; zx-A.x
	sub ebx, [dword A+4] ; zy-A.y
	imul eax, eax ; do kwadratu
	imul ebx, ebx ; do kwadratu
	add ebx, eax ; z tw Pitagorasa kwadrat odleglosci od zrodla w przestrzeni dwuwymiarowej
	mov [dword tmp], ebx ; konwersja na 32 bity
	
	fild dword [tmp]
	fsqrt
	fld dword [Z] ; wspolrzedna Z zrodla swiatla (stala)
	fxch ; liczymy cotangens kata miedzy promieniem prostopadlym a prawdziwym
	fpatan ; arcus cotangens
	fmul dword [radiany] ; przeliczamy z radianow na stopnie
	fsub dword [polowa] ; odejmujemy 45 stopni
	fdiv dword [polowa] ; dzielimy przez 45 stopni
	fmul dword [bialy] ; mnozymy przez kolor bialy
	fiadd dword [A+8] ; dodajemy do naszego koloru
	fistp dword [A+8] ; zwracamy mantyse
	
.punktB: 
	mov rax, rdi
	mov rbx, rsi

	sub eax, [dword B]
	sub ebx, [dword B+4]
	imul eax, eax
	imul ebx, ebx
	add ebx, eax
	mov [dword tmp], ebx
	
	fild dword [tmp]
	fsqrt
	fld dword [Z]
	fxch ; liczymy tanges kata miedzy promieniem prostopadlym a prawdziwym
	fpatan
	fmul dword [radiany]
	fsub dword [polowa]
	fdiv dword [polowa]
	fmul dword [bialy]
	fiadd dword [B+8]
	fistp dword [B+8]

.punktC: 
	mov rax, rdi
	mov rbx, rsi
	
	sub eax, [dword C]
	sub ebx, [dword C+4]
	imul eax, eax
	imul ebx, ebx
	add ebx, eax
	mov [dword tmp], ebx
	
	fild dword [tmp]
	fsqrt
	fld dword [Z]
	fxch ; liczymy tanges kata miedzy promieniem prostopadlym a prawdziwym
	fpatan
	fmul dword [radiany]
	fsub dword [polowa]
	fdiv dword [polowa]
	fmul dword [bialy]
	fiadd dword [C+8]
	fistp dword [C+8]

.d1:
	mov eax, [B+4]
	mov ebx, [A+4]
	cmp eax, ebx; if B.y>A.y
	jg .d1cd
	jmp .d2 ; dx1=0.0 && dk1=0.0

.d1cd:
	sub eax, ebx
	mov [dword tmp], eax
	fild dword [B]
	fild dword [A]
	fsubp
	fild dword [tmp]
	fdivp
	fstp dword [dx1]
	fild dword [B+8]
	fild dword [A+8]
	fsubp
	fild dword [tmp]
	fdivp
	fstp dword [dk1]
	
.d2:
	mov eax, [C+4]
	mov ebx, [A+4]
	cmp eax, ebx
	jg .d2cd
	jmp .d3

.d2cd:
	sub eax, ebx
	mov dword [tmp], eax
	fild dword [C]
	fild dword [A]
	fsubp
	fild dword [tmp]
	fdivp
	fstp dword [dx2]
	fild dword [C+8]
	fild dword [A+8]
	fsubp
	fild dword [tmp]
	fdivp
	fstp dword [dk2]

.d3:
	mov eax, [C+4]
	mov ebx, [B+4]
	cmp eax, ebx
	jg .d3cd
	jmp rysuj1

.d3cd:
	sub eax, ebx
	mov dword [tmp], eax
	fild dword [C]
	fild dword [B]
	fsubp
	fild dword [tmp]
	fdivp
	fstp dword [dx3]
	fild dword [C+8]
	fild dword [B+8]
	fsubp
	fild dword [tmp]
	fdivp
	fstp dword [dk3]
	
rysuj1:
	fild dword [A]
	fst dword [E]
	fstp dword [S]

	fild dword [A+4]
	fist dword [E+4]
	fistp dword [S+4]

	fild dword [A+8]
	fst dword [E+8]
	fstp dword [S+8]


	fld dword [dx1]
	fld dword [dx2]
	fcomip
	fstp dword [tmp] ; usuwamy "smieci"
	jg loop1
	jmp loop3

loop1:
	mov eax, [S+4]
	mov ebx, [B+4]
	cmp eax, ebx
	jg rysuj2

	fld dword [E]
	fld dword [S]
	fcomi
	jg .dkolor
	fstp dword [tmp]
	fstp dword [tmp+4]
	fld dword [zero]
	fstp dword [dk]
	jmp .loopcd

.dkolor:
	fsubp
	fstp dword [tmp]
	fld dword [E+8]
	fld dword [S+8]
	fsubp
	fld dword [tmp]
	fdivp
	fstp dword [dk]   

.loopcd:
	fld dword [S]
	fstp dword [P]
	fild dword [S+4]
	fistp dword [P+4]
	fld dword [S+8]
	fstp dword [P+8]
	fld dword [P]
	fistp dword [Pcalk]
	fld dword [E]
	fistp dword [Ecalk]

.putpixel:
	mov eax, [Pcalk]
	mov ebx, [Ecalk]
	cmp eax, ebx
	jg .inkrementuj

	fild dword [wiersz]
	fild dword [P+4]
	fsubp ; i=300-P.y
	fild dword [kolumna]
	fmulp ; 1200i
	fistp dword [tmp]

	fild dword [integer]
	fild dword [Pcalk]
	fmulp ; 4j
	fild dword [tmp]
	faddp ; 1200i+4j
	fistp dword [tmp]
	mov ecx, dword [tmp]

	fld dword [P+8]
	fistp dword [tmp] ; zaokraglony kolor

	mov eax, [dword tmp]	; kolor
.debug:
	mov [rdx+rcx], rax

	fild dword [Pcalk]
	fiadd dword [plusplus]
	fistp dword [Pcalk]

	fld dword [P+8]
	fld dword [dk]
	faddp
	fstp dword [P+8]
	jmp .putpixel

.inkrementuj:
	fild dword [S+4]
	fiadd dword [plusplus]
	fistp dword [S+4]

	fild dword [E+4]
	fiadd dword [plusplus]
	fistp dword [E+4]

	fld dword [S]
	fld dword [dx2]
	faddp
	fstp dword [S]

	fld dword [S+8]
	fld dword [dk2]
	faddp
	fstp dword [S+8]

	fld dword [E]
	fld dword [dx1]
	faddp
	fstp dword [E]

	fld dword [E+8]
	fld dword [dk1]
	faddp
	fstp dword [E+8]	
	jmp loop1

rysuj2:
	fild dword [B]
	fstp dword [E]
	fild dword [B+4]
	fistp dword [E+4]
	fild dword [B+8]
	fstp dword [E+8]

loop2:
	mov eax, [S+4]
	mov ebx, [C+4]
	cmp eax, ebx
	jg koniec
	
	fld dword [E]
	fld dword [S]
	fcomi
	jg .dkolor
	fstp dword [tmp]
	fld dword [zero]
	fstp dword [dk]
	jmp .loopcd

.dkolor:
	fsubp
	fstp dword [tmp]
	fld dword [E+8]
	fld dword [S+8]
	fsubp
	fld dword [tmp]
	fdivp
	fstp dword [dk]   

.loopcd:
	fld dword [S]
	fstp dword [P]
	fild dword [S+4]
	fistp dword [P+4]
	fld dword [S+8]
	fstp dword [P+8]
	fld dword [P]
	fistp dword [Pcalk]
	fld dword [E]
	fistp dword [Ecalk]

.putpixel:	
	mov eax, [Pcalk]
	mov ebx, [Ecalk]
	cmp eax, ebx
	jg .inkrementuj

	fild dword [wiersz]
	fild dword [P+4]
	fsubp ; i=300-P.y
	fild dword [kolumna]
	fmulp ; 1200i
	fistp dword [tmp]

	fild dword [integer]
	fild dword [Pcalk]
	fmulp ; 4j
	fild dword [tmp]
	faddp ; 1200i+4j
	fistp dword [tmp]
	mov ecx, dword [tmp]

	fld dword [P+8]
	fistp dword [tmp] ; zaokraglony kolor

	mov eax, [dword tmp]	; kolor
.debug:
	mov [rdx+rcx], rax

	fild dword [Pcalk]
	fiadd dword [plusplus]
	fistp dword [Pcalk]

	fld dword [P+8]
	fld dword [dk]
	faddp
	fstp dword [P+8]
	jmp .putpixel

.inkrementuj:
	fild dword [S+4]
	fiadd dword [plusplus]
	fistp dword [S+4]

	fild dword [E+4]
	fiadd dword [plusplus]
	fistp dword [E+4]

	fld dword [S]
	fld dword [dx2]
	faddp
	fstp dword [S]

	fld dword [S+8]
	fld dword [dk2]
	faddp
	fstp dword [S+8]

	fld dword [E]
	fld dword [dx3]
	faddp
	fstp dword [E]

	fld dword [E+8]
	fld dword [dk3]
	faddp
	fstp dword [E+8]	
	jmp loop2

loop3:
	mov eax, [S+4]
	mov ebx, [B+4]
	cmp eax, ebx
	jg rysuj3
	
	fld dword [E]
	fld dword [S]
	fcomi
	jg .dkolor
	fstp dword [tmp]
	fld dword [zero]
	fstp dword [dk]
	jmp .loopcd

.dkolor:
	fsubp
	fstp dword [tmp]
	fld dword [E+8]
	fld dword [S+8]
	fsubp
	fld dword [tmp]
	fdivp
	fstp dword [dk]   

.loopcd:
	fld dword [S]
	fstp dword [P]
	fild dword [S+4]
	fistp dword [P+4]
	fld dword [S+8]
	fstp dword [P+8]
	fld dword [P]
	fistp dword [Pcalk]
	fld dword [E]
	fistp dword [Ecalk]

.putpixel:
	
	mov eax, [Pcalk]
	mov ebx, [Ecalk]
	cmp eax, ebx
	jg .inkrementuj

	fild dword [wiersz]
	fild dword [P+4]
	fsubp ; i=300-P.y
	fild dword [kolumna]
	fmulp ; 1200i
	fistp dword [tmp]

	fild dword [integer]
	fild dword [Pcalk]
	fmulp ; 4j
	fild dword [tmp]
	faddp ; 1200i+4j
	fistp dword [tmp]
	mov ecx, dword [tmp]

	fld dword [P+8]
	fistp dword [tmp] ; zaokraglony kolor

	mov eax, [dword tmp]	; kolor
.debug:
	mov [rdx+rcx], rax

	fild dword [Pcalk]
	fiadd dword [plusplus]
	fistp dword [Pcalk]

	fld dword [P+8]
	fld dword [dk]
	faddp
	fstp dword [P+8]
	jmp .putpixel

.inkrementuj:
	fild dword [S+4]
	fiadd dword [plusplus]
	fistp dword [S+4]

	fild dword [E+4]
	fiadd dword [plusplus]
	fistp dword [E+4]

	fld dword [S]
	fld dword [dx1]
	faddp
	fstp dword [S]

	fld dword [S+8]
	fld dword [dk1]
	faddp
	fstp dword [S+8]

	fld dword [E]
	fld dword [dx2]
	faddp
	fstp dword [E]

	fld dword [E+8]
	fld dword [dk2]
	faddp
	fstp dword [E+8]	
	jmp loop3

rysuj3:
	fild dword [B]
	fstp dword [S]
	fild dword [B+4]
	fistp dword [S+4]
	fild dword [B+8]
	fstp dword [S+8]

loop4:
	mov eax, [S+4]
	mov ebx, [C+4]
	cmp eax, ebx
	jg koniec
	
	fld dword [E]
	fld dword [S]
	fcomi
	jg .dkolor
	fstp dword [tmp]
	fld dword [zero]
	fstp dword [dk]
	jmp .loopcd

.dkolor:
	fsubp
	fstp dword [tmp]
	fld dword [E+8]
	fld dword [S+8]
	fsubp
	fld dword [tmp]
	fdivp
	fstp dword [dk]   

.loopcd:
	fld dword [S]
	fstp dword [P]
	fild dword [S+4]
	fistp dword [P+4]
	fld dword [S+8]
	fstp dword [P+8]
	fld dword [P]
	fistp dword [Pcalk]
	fld dword [E]
	fistp dword [Ecalk]

.putpixel:
	mov eax, [Pcalk]
	mov ebx, [Ecalk]
	cmp eax, ebx
	jg .inkrementuj

	fild dword [wiersz]
	fild dword [P+4]
	fsubp ; i=300-P.y
	fild dword [kolumna]
	fmulp ; 1200i
	fistp dword [tmp]

	fild dword [integer]
	fild dword [Pcalk]
	fmulp ; 4j
	fild dword [tmp]
	faddp ; 1200i+4j
	fistp dword [tmp]
	mov ecx, dword [tmp]

	fld dword [P+8]
	fistp dword [tmp] ; zaokraglony kolor

	mov eax, [dword tmp]	; kolor
.debug:
	mov [rdx+rcx], rax

	fild dword [Pcalk]
	fiadd dword [plusplus]
	fistp dword [Pcalk]

	fld dword [P+8]
	fld dword [dk]
	faddp
	fstp dword [P+8]
	jmp .putpixel

.inkrementuj:
	fild dword [S+4]
	fiadd dword [plusplus]
	fistp dword [S+4]

	fild dword [E+4]
	fiadd dword [plusplus]
	fistp dword [E+4]

	fld dword [S]
	fld dword [dx3]
	faddp
	fstp dword [S]

	fld dword [S+8]
	fld dword [dk3]
	faddp
	fstp dword [S+8]

	fld dword [E]
	fld dword [dx2]
	faddp
	fstp dword [E]

	fld dword [E+8]
	fld dword [dk2]
	faddp
	fstp dword [E+8]	
	jmp loop4	

koniec:
	mov rax, 0
	mov rsp, rbp 	 ; niszczmy ramkê 
	pop rbp     	 ; przywróæ starego RBP
	ret		 ; koniec funkcji



