w = Dir["warriors/94nop/*.red"]
runs = 100
#app = "pmars-server.exe"
#app = "C:\\martin\\dev\\YaceReloaded\\vs\\x64\\Release\\YaceReloaded.exe"
app = "C:\\dev\\YaceReloaded.git\\vs\\x64\\Release\\YaceReloaded.exe"

reference = [
"33 18\n49 18\n",
"58 9\n33 9\n",
"31 16\n53 16\n",
"33 14\n53 14\n",
"17 22\n61 22\n",
"26 29\n45 29\n",
"38 17\n45 17\n",
"45 13\n42 13\n",
"56 9\n35 9\n",
"45 12\n43 12\n",
"36 32\n32 32\n",
"49 12\n39 12\n",
"51 15\n34 15\n",
"37 19\n44 19\n",
"27 11\n62 11\n",
"36 16\n48 16\n",
"43 17\n40 17\n",
"53 13\n34 13\n",
"16 24\n60 24\n",
"37 5\n58 5\n",
"54 14\n32 14\n",
"19 15\n66 15\n",
"28 26\n46 26\n",
"44 11\n45 11\n",
"53 23\n24 23\n",
"38 30\n32 30\n",
"48 11\n41 11\n",
"41 13\n46 13\n",
"41 10\n49 10\n",
"50 5\n45 5\n",
"40 10\n50 10\n",
"49 1\n50 1\n",
"27 17\n56 17\n",
"30 8\n62 8\n",
"19 8\n73 8\n",
"26 30\n44 30\n",
"33 10\n57 10\n",
"49 11\n40 11\n",
"42 5\n53 5\n",
"40 8\n52 8\n",
"31 25\n44 25\n",
"44 8\n48 8\n",
"66 10\n24 10\n",
"22 14\n64 14\n",
"44 5\n51 5\n",
"40 21\n39 21\n",
"22 17\n61 17\n",
"61 9\n30 9\n",
"34 7\n59 7\n",
"27 7\n66 7\n",
"45 7\n48 7\n",
"24 5\n71 5\n",
"32 22\n46 22\n",
"38 8\n54 8\n",
"47 9\n44 9\n",
"32 20\n48 20\n",
"45 6\n49 6\n",
"33 11\n56 11\n",
"45 10\n45 10\n",
"43 16\n41 16\n",
"46 11\n43 11\n",
"65 17\n18 17\n",
"9 81\n10 81\n",
"13 80\n7 80\n",
"12 74\n14 74\n",
"7 78\n15 78\n",
"23 66\n11 66\n",
"53 11\n36 11\n",
"68 14\n18 14\n",
"42 22\n36 22\n",
"5 88\n7 88\n",
"60 13\n27 13\n",
"46 25\n29 25\n",
"9 85\n6 85\n",
"12 75\n13 75\n",
"7 75\n18 75\n",
"9 77\n14 77\n",
"47 16\n37 16\n",
"12 73\n15 73\n",
"14 75\n11 75\n",
"54 4\n42 4\n",
"13 66\n21 66\n",
"13 75\n12 75\n",
"41 14\n45 14\n",
"62 9\n29 9\n",
"11 73\n16 73\n",
"57 9\n34 9\n",
"16 66\n18 66\n",
"22 65\n13 65\n",
"54 12\n34 12\n",
"41 14\n45 14\n",
"70 13\n17 13\n",
"8 75\n17 75\n",
"12 81\n7 81\n",
"13 65\n22 65\n",
"11 71\n18 71\n",
"29 65\n6 65\n",
"53 11\n36 11\n",
"62 10\n28 10\n",
"48 17\n35 17\n",
"14 78\n8 78\n",
"62 9\n29 9\n",
"56 13\n31 13\n",
"5 31\n64 31\n",
"21 65\n14 65\n",
"8 77\n15 77\n",
"10 76\n14 76\n",
"50 7\n43 7\n",
"12 76\n12 76\n",
"12 74\n14 74\n",
"57 2\n41 2\n",
"17 65\n18 65\n",
"13 76\n11 76\n",
"42 10\n48 10\n",
"63 10\n27 10\n",
"12 72\n16 72\n",
"65 7\n28 7\n",
"11 74\n15 74\n",
"23 68\n9 68\n",
"53 12\n35 12\n",
"66 20\n14 20\n",
"65 5\n30 5\n",
"17 70\n13 70\n",
"15 71\n14 71\n",
"11 80\n9 80\n",
"7 77\n16 77\n",
"13 67\n20 67\n",
"58 6\n36 6\n",
"61 11\n28 11\n",
"35 11\n54 11\n",
"21 67\n12 67\n",
"47 16\n37 16\n",
"45 15\n40 15\n",
"1 90\n9 90\n",
"10 68\n22 68\n",
"15 69\n16 69\n",
"33 53\n14 53\n",
"55 17\n28 17\n",
"4 74\n22 74\n",
"50 35\n15 35\n",
"45 4\n51 4\n",
"10 70\n20 70\n",
"23 62\n15 62\n",
"60 22\n18 22\n",
"53 11\n36 11\n",
"23 61\n16 61\n",
"63 14\n23 14\n",
"15 68\n17 68\n",
"16 62\n22 62\n",
"50 11\n39 11\n",
"45 30\n25 30\n",
"32 29\n39 29\n",
"10 80\n10 80\n",
"9 81\n10 81\n",
"18 78\n4 78\n",
"14 76\n10 76\n",
"33 57\n10 57\n",
"46 24\n30 24\n",
"46 26\n28 26\n",
"31 33\n36 33\n",
"31 54\n15 54\n",
"42 33\n25 33\n",
"35 44\n21 44\n",
"4 81\n15 81\n",
"25 68\n7 68\n",
"19 70\n11 70\n",
"23 67\n10 67\n",
"38 42\n20 42\n",
"15 74\n11 74\n",
"43 45\n12 45\n",
"25 5\n70 5\n",
"16 72\n12 72\n",
"20 72\n8 72\n",
"51 19\n30 19\n",
"39 26\n35 26\n",
"14 72\n14 72\n",
"51 20\n29 20\n",
"12 76\n12 76\n",
"15 72\n13 72\n",
"45 31\n24 31\n",
"30 17\n53 17\n",
"40 8\n52 8\n",
"8 61\n31 61\n",
"12 58\n30 58\n",
"26 60\n14 60\n",
"7 65\n28 65\n",
"26 40\n34 40\n",
"55 14\n31 14\n",
"43 15\n42 15\n",
"43 19\n38 19\n",
"17 39\n44 39\n",
"36 10\n54 10\n",
"38 23\n39 23\n",
"14 52\n34 52\n",
"30 35\n35 35\n",
"13 50\n37 50\n",
"15 64\n21 64\n",
"44 19\n37 19\n",
"21 49\n30 49\n",
"10 61\n29 61\n",
"33 16\n51 16\n",
"23 45\n32 45\n",
"5 62\n33 62\n",
"39 13\n48 13\n",
"35 27\n38 27\n",
"19 44\n37 44\n",
"50 15\n35 15\n",
"12 52\n36 52\n",
"16 47\n37 47\n",
"33 14\n53 14\n",
"45 16\n39 16\n",
"42 11\n47 11\n",
"29 14\n57 14\n",
"31 12\n57 12\n",
"32 8\n60 8\n",
"31 21\n48 21\n",
"24 20\n56 20\n",
"40 14\n46 14\n",
"41 8\n51 8\n",
"43 8\n49 8\n",
"44 20\n36 20\n",
"42 7\n51 7\n",
"37 5\n58 5\n",
"36 15\n49 15\n",
"27 9\n64 9\n",
"51 17\n32 17\n",
"27 5\n68 5\n",
"52 17\n31 17\n",
"29 13\n58 13\n",
"26 8\n66 8\n",
"44 5\n51 5\n",
"25 11\n64 11\n",
"34 20\n46 20\n",
"33 15\n52 15\n",
"49 7\n44 7\n",
"27 33\n40 33\n",
"46 9\n45 9\n",
"41 19\n40 19\n",
"34 2\n64 2\n",
"41 11\n48 11\n",
"41 9\n50 9\n",
"58 5\n37 5\n",
"24 10\n66 10\n",
"26 8\n66 8\n",
"22 12\n66 12\n",
"27 35\n38 35\n",
"42 10\n48 10\n",
"47 9\n44 9\n",
"50 3\n47 3\n",
"43 7\n50 7\n",
"29 38\n33 38\n",
"56 5\n39 5\n",
"56 8\n36 8\n",
"35 15\n50 15\n",
"33 11\n56 11\n",
"40 21\n39 21\n",
"30 13\n57 13\n",
"60 11\n29 11\n",
"29 17\n54 17\n",
"36 10\n54 10\n",
"57 5\n38 5\n",
"22 13\n65 13\n",
"35 24\n41 24\n",
"35 11\n54 11\n",
"49 7\n44 7\n",
"37 23\n40 23\n",
"64 8\n28 8\n",
"48 24\n28 24\n",
"45 10\n45 10\n",
"27 16\n57 16\n",
"41 10\n49 10\n",
"49 7\n44 7\n",
"35 19\n46 19\n",
"30 16\n54 16\n",
"41 14\n45 14\n",
"26 32\n42 32\n",
"31 17\n52 17\n",
"43 9\n48 9\n",
"45 9\n46 9\n",
"50 4\n46 4\n",
"33 24\n43 24\n",
"43 4\n53 4\n",
"49 10\n41 10\n",
"38 26\n36 26\n",
"17 19\n64 19\n",
"48 21\n31 21\n",
"29 13\n58 13\n",
"50 7\n43 7\n",
"35 10\n55 10\n",
"31 7\n62 7\n",
"45 3\n52 3\n",
"45 12\n43 12\n",
"18 32\n50 32\n",
"32 23\n45 23\n",
"40 4\n56 4\n",
"33 35\n32 35\n",
"43 7\n50 7\n",
"40 17\n43 17\n",
"34 18\n48 18\n",
"46 17\n37 17\n",
"24 32\n44 32\n",
"31 23\n46 23\n",
"10 75\n15 75\n",
"14 76\n10 76\n",
"23 53\n24 53\n",
"22 59\n19 59\n",
"26 54\n20 54\n",
"34 18\n48 18\n",
"42 34\n24 34\n",
"33 31\n36 31\n",
"11 71\n18 71\n",
"31 26\n43 26\n",
"40 41\n19 41\n",
"9 73\n18 73\n",
"21 67\n12 67\n",
"7 74\n19 74\n",
"8 76\n16 76\n",
"34 42\n24 42\n",
"17 67\n16 67\n",
"19 70\n11 70\n",
"45 12\n43 12\n",
"16 57\n27 57\n",
"8 77\n15 77\n",
"36 26\n38 26\n",
"31 34\n35 34\n",
"16 61\n23 61\n",
"35 19\n46 19\n",
"5 66\n29 66\n",
"10 76\n14 76\n",
"43 35\n22 35\n",
"29 27\n44 27\n",
"33 5\n62 5\n",
"27 12\n61 12\n",
"28 12\n60 12\n",
"25 20\n55 20\n",
"26 35\n39 35\n",
"35 15\n50 15\n",
"36 8\n56 8\n",
"42 10\n48 10\n",
"55 4\n41 4\n",
"31 25\n44 25\n",
"43 10\n47 10\n",
"63 12\n25 12\n",
"40 13\n47 13\n",
"30 6\n64 6\n",
"39 18\n43 18\n",
"21 16\n63 16\n",
"55 9\n36 9\n",
"27 11\n62 11\n",
"22 7\n71 7\n",
"45 7\n48 7\n",
"25 15\n60 15\n",
"25 29\n46 29\n",
"30 22\n48 22\n",
"48 5\n47 5\n",
"15 28\n57 28\n",
"46 6\n48 6\n",
"40 19\n41 19\n",
"36 8\n56 8\n",
"41 18\n41 18\n",
"40 14\n46 14\n",
"17 9\n74 9\n",
"42 16\n42 16\n",
"52 13\n35 13\n",
"31 11\n58 11\n",
"25 34\n41 34\n",
"34 18\n48 18\n",
"53 12\n35 12\n",
"36 8\n56 8\n",
"40 9\n51 9\n",
"23 35\n42 35\n",
"27 10\n63 10\n",
"41 12\n47 12\n",
"28 27\n45 27\n",
"42 11\n47 11\n",
"28 28\n44 28\n",
"36 14\n50 14\n",
"49 4\n47 4\n",
"29 12\n59 12\n",
"28 13\n59 13\n",
"47 5\n48 5\n",
"37 14\n49 14\n",
"31 26\n43 26\n",
"34 15\n51 15\n",
"39 11\n50 11\n",
"33 36\n31 36\n",
"46 1\n53 1\n",
"33 20\n47 20\n",
"37 16\n47 16\n",
"36 21\n43 21\n",
"60 17\n23 17\n",
"57 15\n28 15\n",
"12 81\n7 81\n",
"65 27\n8 27\n",
"12 83\n5 83\n",
"9 81\n10 81\n",
"24 53\n23 53\n",
"43 18\n39 18\n",
"47 20\n33 20\n",
"40 22\n38 22\n",
"10 82\n8 82\n",
"36 20\n44 20\n",
"40 23\n37 23\n",
"9 87\n4 87\n",
"28 63\n9 63\n",
"14 74\n12 74\n",
"10 83\n7 83\n",
"42 17\n41 17\n",
"10 79\n11 79\n",
"14 74\n12 74\n",
"37 9\n54 9\n",
"12 77\n11 77\n",
"53 36\n11 36\n",
"38 17\n45 17\n",
"41 23\n36 23\n",
"13 75\n12 75\n",
"47 19\n34 19\n",
"11 81\n8 81\n",
"23 69\n8 69\n",
"44 25\n31 25\n",
"62 14\n24 14\n",
"53 12\n35 12\n",
"7 72\n21 72\n",
"20 63\n17 63\n",
"21 71\n8 71\n",
"8 69\n23 69\n",
"24 43\n33 43\n",
"60 10\n30 10\n",
"52 15\n33 15\n",
"58 19\n23 19\n",
"16 57\n27 57\n",
"54 14\n32 14\n",
"49 16\n35 16\n",
"9 62\n29 62\n",
"20 60\n20 60\n",
"27 59\n14 59\n",
"21 58\n21 58\n",
"61 12\n27 12\n",
"18 65\n17 65\n",
"23 51\n26 51\n",
"44 7\n49 7\n",
"23 49\n28 49\n",
"15 61\n24 61\n",
"59 7\n34 7\n",
"63 13\n24 13\n",
"19 54\n27 54\n",
"62 15\n23 15\n",
"15 64\n21 64\n",
"25 57\n18 57\n",
"46 16\n38 16\n",
"54 15\n31 15\n",
"51 17\n32 17\n",
"30 57\n13 57\n",
"22 60\n18 60\n",
"21 64\n15 64\n",
"11 65\n24 65\n",
"30 53\n17 53\n",
"44 16\n40 16\n",
"37 19\n44 19\n",
"39 25\n36 25\n",
"29 60\n11 60\n",
"47 16\n37 16\n",
"46 20\n34 20\n",
"15 67\n18 67\n",
"19 65\n16 65\n",
"25 65\n10 65\n",
"39 51\n10 51\n",
"30 29\n41 29\n",
"17 64\n19 64\n",
"41 45\n14 45\n",
"54 6\n40 6\n",
"21 52\n27 52\n",
"25 67\n8 67\n",
"51 13\n36 13\n",
"40 21\n39 21\n",
"29 41\n30 41\n",
"56 10\n34 10\n",
"40 35\n25 35\n",
"30 61\n9 61\n",
"37 26\n37 26\n",
"56 11\n33 11\n",
"58 12\n30 12\n",
"13 76\n11 76\n",
"16 78\n6 78\n",
"11 53\n36 53\n",
"13 57\n30 57\n",
"27 61\n12 61\n",
"77 7\n16 7\n",
"61 14\n25 14\n",
"54 12\n34 12\n",
"14 79\n7 79\n",
"65 7\n28 7\n",
"47 21\n32 21\n",
"14 82\n4 82\n",
"19 60\n21 60\n",
"5 72\n23 72\n",
"11 78\n11 78\n",
"57 14\n29 14\n",
"15 71\n14 71\n",
"23 62\n15 62\n",
"59 4\n37 4\n",
"15 53\n32 53\n",
"10 78\n12 78\n",
"45 7\n48 7\n",
"56 12\n32 12\n",
"13 62\n25 62\n",
"56 8\n36 8\n",
"10 63\n27 63\n",
"26 66\n8 66\n",
"47 18\n35 18\n",
"30 13\n57 13\n",
"40 6\n54 6\n",
"29 17\n54 17\n",
"37 15\n48 15\n",
"40 8\n52 8\n",
"34 34\n32 34\n",
"39 13\n48 13\n",
"38 12\n50 12\n",
"37 4\n59 4\n",
"47 5\n48 5\n",
"24 40\n36 40\n",
"47 5\n48 5\n",
"45 3\n52 3\n",
"37 22\n41 22\n",
"32 12\n56 12\n",
"39 22\n39 22\n",
"21 15\n64 15\n",
"43 16\n41 16\n",
"36 24\n40 24\n",
"37 17\n46 17\n",
"48 7\n45 7\n",
"37 12\n51 12\n",
"28 31\n41 31\n",
"32 18\n50 18\n",
"51 8\n41 8\n",
"31 40\n29 40\n",
"40 7\n53 7\n",
"34 27\n39 27\n",
"26 10\n64 10\n",
"41 14\n45 14\n",
"49 26\n25 26\n",
"52 21\n27 21\n",
"10 77\n13 77\n",
"7 80\n13 80\n",
"11 84\n5 84\n",
"6 82\n12 82\n",
"25 61\n14 61\n",
"50 23\n27 23\n",
"59 17\n24 17\n",
"53 15\n32 15\n",
"19 67\n14 67\n",
"57 16\n27 16\n",
"48 20\n32 20\n",
"9 77\n14 77\n",
"22 59\n19 59\n",
"18 62\n20 62\n",
"13 68\n19 68\n",
"49 18\n33 18\n",
"12 66\n22 66\n",
"29 55\n16 55\n",
"42 8\n50 8\n",
"14 73\n13 73\n",
"11 76\n13 76\n",
"48 18\n34 18\n",
"57 13\n30 13\n",
"17 68\n15 68\n",
"51 17\n32 17\n",
"14 70\n16 70\n",
"19 63\n18 63\n",
"49 24\n27 24\n",
"54 5\n41 5\n",
"62 6\n32 6\n",
"8 77\n15 77\n",
"9 82\n9 82\n",
"8 38\n54 38\n",
"13 30\n57 30\n",
"33 52\n15 52\n",
"74 1\n25 1\n",
"53 12\n35 12\n",
"58 10\n32 10\n",
"13 67\n20 67\n",
"62 13\n25 13\n",
"46 15\n39 15\n",
"7 81\n12 81\n",
"25 44\n31 44\n",
"11 49\n40 49\n",
"12 73\n15 73\n",
"62 14\n24 14\n",
"15 49\n36 49\n",
"12 72\n16 72\n",
"65 5\n30 5\n",
"14 31\n55 31\n",
"8 73\n19 73\n",
"42 8\n50 8\n",
"61 9\n30 9\n",
"13 62\n25 62\n",
"74 4\n22 4\n",
"9 63\n28 63\n",
"18 63\n19 63\n",
"47 9\n44 9\n",
"22 19\n59 19\n",
"48 6\n46 6\n",
"31 4\n65 4\n",
"32 5\n63 5\n",
"39 4\n57 4\n",
"61 9\n30 9\n",
"39 21\n40 21\n",
"42 6\n52 6\n",
"38 7\n55 7\n",
"48 8\n44 8\n",
"48 5\n47 5\n",
"39 3\n58 3\n",
"48 4\n48 4\n",
"61 12\n27 12\n",
"41 4\n55 4\n",
"38 7\n55 7\n",
"35 2\n63 2\n",
"60 3\n37 3\n",
"49 2\n49 2\n",
"25 3\n72 3\n",
"52 1\n47 1\n",
"36 5\n59 5\n",
"33 14\n53 14\n",
"34 28\n38 28\n",
"45 4\n51 4\n",
"44 12\n44 12\n",
"51 4\n45 4\n",
"47 8\n45 8\n",
"31 3\n66 3\n",
"46 9\n45 9\n",
"65 19\n16 19\n",
"61 7\n32 7\n",
"17 70\n13 70\n",
"21 65\n14 65\n",
"21 66\n13 66\n",
"9 76\n15 76\n",
"28 48\n24 48\n",
"59 6\n35 6\n",
"66 7\n27 7\n",
"36 7\n57 7\n",
"16 69\n15 69\n",
"45 12\n43 12\n",
"52 14\n34 14\n",
"3 83\n14 83\n",
"18 56\n26 56\n",
"20 65\n15 65\n",
"33 53\n14 53\n",
"54 18\n28 18\n",
"14 66\n20 66\n",
"47 39\n14 39\n",
"48 3\n49 3\n",
"15 63\n22 63\n",
"24 58\n18 58\n",
"55 21\n24 21\n",
"57 13\n30 13\n",
"29 52\n19 52\n",
"65 14\n21 14\n",
"19 59\n22 59\n",
"18 59\n23 59\n",
"48 9\n43 9\n",
"38 32\n30 32\n",
"46 24\n30 24\n",
"6 84\n10 84\n",
"9 85\n6 85\n",
"13 62\n25 62\n",
"6 76\n18 76\n",
"28 65\n7 65\n",
"37 33\n30 33\n",
"35 28\n37 28\n",
"56 22\n22 22\n",
"8 80\n12 80\n",
"41 35\n24 35\n",
"43 35\n22 35\n",
"5 28\n67 28\n",
"12 73\n15 73\n",
"3 74\n23 74\n",
"8 85\n7 85\n",
"43 24\n33 24\n",
"9 77\n14 77\n",
"17 77\n6 77\n",
"46 20\n34 20\n",
"7 66\n27 66\n",
"11 81\n8 81\n",
"40 21\n39 21\n",
"38 34\n28 34\n",
"13 72\n15 72\n",
"53 24\n23 24\n",
"10 67\n23 67\n",
"11 74\n15 74\n",
"47 24\n29 24\n",
"40 18\n42 18\n",
"48 11\n41 11\n",
"40 16\n44 16\n",
"36 13\n51 13\n",
"36 13\n51 13\n",
"30 34\n36 34\n",
"26 18\n56 18\n",
"51 14\n35 14\n",
"45 14\n41 14\n",
"42 15\n43 15\n",
"32 34\n34 34\n",
"43 15\n42 15\n",
"42 20\n38 20\n",
"41 16\n43 16\n",
"23 14\n63 14\n",
"43 15\n42 15\n",
"47 12\n41 12\n",
"42 15\n43 15\n",
"31 17\n52 17\n",
"48 2\n50 2\n",
"34 20\n46 20\n",
"32 16\n52 16\n",
"36 26\n38 26\n",
"39 11\n50 11\n",
"40 17\n43 17\n",
"41 33\n26 33\n",
"30 19\n51 19\n",
"47 16\n37 16\n",
"55 9\n36 9\n",
"38 22\n40 22\n",
"37 25\n38 25\n",
"43 11\n46 11\n",
"27 14\n59 14\n",
"35 13\n52 13\n",
"30 16\n54 16\n",
"38 36\n26 36\n",
"43 24\n33 24\n",
"42 9\n49 9\n",
"40 4\n56 4\n",
"40 8\n52 8\n",
"31 32\n37 32\n",
"38 14\n48 14\n",
"47 7\n46 7\n",
"35 22\n43 22\n",
"24 19\n57 19\n",
"35 26\n39 26\n",
"34 14\n52 14\n",
"43 12\n45 12\n",
"36 12\n52 12\n",
"24 14\n62 14\n",
"47 9\n44 9\n",
"28 20\n52 20\n",
"25 36\n39 36\n",
"35 18\n47 18\n",
"43 8\n49 8\n",
"17 37\n46 37\n",
"55 7\n38 7\n",
"35 24\n41 24\n",
"34 13\n53 13\n",
"39 17\n44 17\n",
"37 25\n38 25\n",
"48 22\n30 22\n",
"17 70\n13 70\n",
"16 69\n15 69\n",
"16 64\n20 64\n",
"7 73\n20 73\n",
"35 42\n23 42\n",
"49 26\n25 26\n",
"41 25\n34 25\n",
"31 36\n33 36\n",
"19 69\n12 69\n",
"63 22\n15 22\n",
"25 45\n30 45\n",
"13 72\n15 72\n",
"36 53\n11 53\n",
"39 44\n17 44\n",
"24 62\n14 62\n",
"31 39\n30 39\n",
"15 68\n17 68\n",
"30 58\n12 58\n",
"42 19\n39 19\n",
"21 52\n27 52\n",
"20 67\n13 67\n",
"31 33\n36 33\n",
"46 36\n18 36\n",
"22 64\n14 64\n",
"45 27\n28 27\n",
"24 55\n21 55\n",
"21 65\n14 65\n",
"44 31\n25 31\n",
"32 11\n57 11\n",
"40 4\n56 4\n",
"25 15\n60 15\n",
"17 12\n71 12\n",
"44 13\n43 13\n",
"33 18\n49 18\n",
"26 19\n55 19\n",
"58 7\n35 7\n",
"25 3\n72 3\n",
"53 7\n40 7\n",
"39 26\n35 26\n",
"58 7\n35 7\n",
"41 8\n51 8\n",
"49 17\n34 17\n",
"25 9\n66 9\n",
"38 12\n50 12\n",
"32 11\n57 11\n",
"51 4\n45 4\n",
"32 10\n58 10\n",
"17 5\n78 5\n",
"48 8\n44 8\n",
"36 10\n54 10\n",
"25 23\n52 23\n",
"41 20\n39 20\n",
"34 8\n58 8\n",
"23 33\n44 33\n",
"47 8\n45 8\n",
"52 11\n37 11\n",
"25 3\n72 3\n",
"47 7\n46 7\n",
"46 13\n41 13\n",
"48 14\n38 14\n",
"21 68\n11 68\n",
"21 70\n9 70\n",
"21 60\n19 60\n",
"19 65\n16 65\n",
"41 45\n14 45\n",
"44 15\n41 15\n",
"39 20\n41 20\n",
"35 21\n44 21\n",
"25 64\n11 64\n",
"52 11\n37 11\n",
"35 20\n45 20\n",
"11 76\n13 76\n",
"21 57\n22 57\n",
"28 42\n30 42\n",
"31 60\n9 60\n",
"38 25\n37 25\n",
"19 67\n14 67\n",
"28 60\n12 60\n",
"52 7\n41 7\n",
"23 51\n26 51\n",
"21 68\n11 68\n",
"45 13\n42 13\n",
"48 17\n35 17\n",
"21 54\n25 54\n",
"42 7\n51 7\n",
"21 59\n20 59\n",
"35 52\n13 52\n",
"48 22\n30 22\n",
"44 10\n46 10\n",
"47 12\n41 12\n",
"13 66\n21 66\n",
"12 70\n18 70\n",
"22 57\n21 57\n",
"12 66\n22 66\n",
"26 49\n25 49\n",
"57 6\n37 6\n",
"43 19\n38 19\n",
"45 15\n40 15\n",
"11 77\n12 77\n",
"55 4\n41 4\n",
"47 16\n37 16\n",
"10 73\n17 73\n",
"21 55\n24 55\n",
"13 58\n29 58\n",
"16 69\n15 69\n",
"57 14\n29 14\n",
"17 63\n20 63\n",
"15 61\n24 61\n",
"66 2\n32 2\n",
"18 49\n33 49\n",
"10 65\n25 65\n",
"48 10\n42 10\n",
"56 12\n32 12\n",
"13 70\n17 70\n",
"68 6\n26 6\n",
"11 64\n25 64\n",
"24 59\n17 59\n",
"48 9\n43 9\n",
"44 14\n42 14\n",
"44 17\n39 17\n",
"34 10\n56 10\n",
"38 11\n51 11\n",
"31 15\n54 15\n",
"16 37\n47 37\n",
"42 15\n43 15\n",
"47 20\n33 20\n",
"47 15\n38 15\n",
"47 20\n33 20\n",
"28 36\n36 36\n",
"50 10\n40 10\n",
"41 17\n42 17\n",
"36 25\n39 25\n",
"35 14\n51 14\n",
"37 26\n37 26\n",
"34 10\n56 10\n",
"38 19\n43 19\n",
"26 17\n57 17\n",
"41 7\n52 7\n",
"35 17\n48 17\n",
"36 6\n58 6\n",
"28 22\n50 22\n",
"31 17\n52 17\n",
"59 12\n29 12\n",
"28 35\n37 35\n",
"49 10\n41 10\n",
"33 20\n47 20\n",
"38 14\n48 14\n",
"48 11\n41 11\n"
]

loop do
	i = 0
	t = Time.now
	w.each do |w1|
		w.each do |w2|
			cmd = "#{app} -bkF 4000 -r #{runs} #{w1} #{w2} 2>nul"
			output = `#{cmd}`
			if (!output.eql?(reference[i]))
				puts "#{cmd}"
				p reference[i]
				p output
			end
			i += 1
		end
    STDOUT.print "."
	end
	t = Time.now - t

	rounds = runs * w.length * w.length
	puts "#{rounds/t} per second."
end