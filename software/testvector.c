#include <stdint.h>                                              
                                                                 
// This file's content is created by the testvector generator    
// python script for seed = 2017                    
//                                                               
//  The variables are defined for the RSA                        
// encryption and decryption operations. And they are assigned   
// by the script for the generated testvector. Do not create a   
// new variable in this file.                                    
//                                                               
// When you are submitting your results, be careful to verify    
// the test vectors created for seed = 2017.1, to 2017.5         
// To create them, run your script as:                           
//   $ python testvectors.py crtrsa 2017.1                       
                                                                 
// message                                                       
uint32_t M[32] = {0xf1dd1c84, 0xe92a895c, 0x65e91c27, 0x6268b2d1, 0x9da12f6d, 0x58d34e92, 0xbc808f10, 0x4028fd54, 0xc3813353, 0x078748b0, 0x1cab16c8, 0x014675ee, 0x3697dc59, 0x2d6bd89d, 0x47632a98, 0x17a771f2, 0x96891211, 0x49bcf099, 0x90d3b199, 0x01ee22a6, 0x2bb36163, 0x3acf6239, 0x20195402, 0x41489669, 0xd227e1f3, 0x83915e17, 0x66bb7084, 0x5520edcd, 0x2be519ae, 0x1088258d, 0x1fd4f270, 0x81f52ce8};                 
                                                                 
// prime p and q                                                 
uint32_t p[16] = {0x620dd0f1, 0x224245ff, 0xd1147ed9, 0xdab39cdd, 0xa298a7da, 0x0a60a343, 0x83774f81, 0xb41fc8d4, 0x82c309a9, 0xf761eed7, 0x08f6cb25, 0xd37defa1, 0x4e7967cc, 0x5b20f7ff, 0x44d172b7, 0xc908f379};                 
uint32_t q[16] = {0xd3f902cd, 0x71e672ce, 0xf6f50c49, 0x3427161c, 0x551a2559, 0x23a32b09, 0x88b180a6, 0x5436996d, 0xf642085b, 0x72c9c54c, 0xd155e595, 0x9dde59bc, 0x72e0606a, 0x32db1d77, 0x7d5663e4, 0xdea144a7};                 
                                                                 
// modulus                                                       
uint32_t N[32]       = {0x7e1b32fd, 0xae8542da, 0xc97157d4, 0x165003f2, 0xccba6cdd, 0x1bd84b26, 0x07ac44f5, 0x5a56c2df, 0xcf4525b5, 0x7872b881, 0x25713a17, 0xd5f47c97, 0xc6d21882, 0x255b6f31, 0x1d1e83a9, 0x99cba456, 0x343fdebc, 0xaa8ad6bb, 0xf027da35, 0xb5f29e48, 0x06f59855, 0xff81adea, 0xb33c6ee0, 0xedbfcd97, 0x7bfb18bf, 0x988f2839, 0x92168569, 0x0416f41d, 0xb620e630, 0x58d962f4, 0x30e229ed, 0xaed467ae};           
uint32_t N_prime[32] = {0xda0e05ab, 0xbc8b741b, 0x5bfbf55d, 0x168928f9, 0xc7e475e2, 0x394fd02b, 0x4044a185, 0x2a36ef81, 0x2e5a66b2, 0x7cbe96fc, 0x6b647aa9, 0x665adcde, 0xb31ea5de, 0xe813f734, 0x533a7594, 0x5b86bbb9, 0x15845706, 0x54caaf45, 0x8144da06, 0xc68a33b0, 0x0064d555, 0x5d7dcb7b, 0x3648d150, 0xd9d9c4a6, 0xdd71c161, 0xda96e5cd, 0xf4bef837, 0x88bf53bf, 0xbb81bb28, 0x371efe56, 0x59918861, 0x076eee8d};     
                                                                 
// encryption exponent                                           
uint32_t e[32] = {0x0000df99};                  
uint32_t e_len = 16;                                             
                                                                 
// decryption exponent, reduced to p and q                       
uint32_t d_p[16] = {0x078975a9, 0xf9af6d2d, 0x17eeeea6, 0x4ef4835f, 0x0659e669, 0xe54ba84c, 0x8ef47d82, 0xf5a06014, 0x0b78111d, 0xeb554b70, 0x87f0710a, 0x973fdd84, 0x2e63e2ca, 0xd22be707, 0x9ff83978, 0x38231800};             
uint32_t d_q[16] = {0x89192d81, 0x0d94e3c2, 0xb61bc2dc, 0xfc901994, 0x6b6fc30c, 0x3a838d4a, 0xafd0112d, 0x278cfda7, 0xd0b419c5, 0xe3d50de2, 0x8e4640ce, 0x56496d9a, 0xfa4c1177, 0xc6d749b4, 0xf848638b, 0xc0cb77a0};             
uint32_t d_p_len =  510;   
uint32_t d_q_len =  512;   
                                                                 
// x_p and x_q                                                   
uint32_t x_p[32] = {0xaea573e1, 0x0a8d28a6, 0xcd4749ac, 0x9f3e3ebb, 0xc5bec85f, 0xfe385014, 0xa6658560, 0x2375e0be, 0x57338ecd, 0x77eb286d, 0xa16d25e2, 0x0ad87828, 0xf9c8ce9c, 0xa58d5db8, 0x71f0252c, 0x9610281d, 0x2dc601c9, 0x9d29d574, 0x51c9b4a3, 0x538838a2, 0x47d96612, 0x3d1195d7, 0x48dac72d, 0x5fcabf42, 0x8e99c5e7, 0x94796c73, 0x5d9b4264, 0xeef5ae01, 0x400ead87, 0xc408ad1c, 0xfc8b7747, 0xaaff3fe4};             
uint32_t x_q[32] = {0xcf75bf1d, 0xa3f81a33, 0xfc2a0e28, 0x7711c536, 0x06fba47d, 0x1d9ffb12, 0x6146bf94, 0x36e0e220, 0x781196e8, 0x00879014, 0x84041435, 0xcb1c046e, 0xcd0949e6, 0x7fce1178, 0xab2e5e7c, 0x03bb7c38, 0x0679dcf3, 0x0d610147, 0x9e5e2592, 0x626a65a6, 0xbf1c3243, 0xc2701812, 0x6a61a7b3, 0x8df50e55, 0xed6152d8, 0x0415bbc5, 0x347b4305, 0x1521461c, 0x761238a8, 0x94d0b5d8, 0x3456b2a5, 0x03d527c9};             
                                                                 
// R mod p, and R mod q, (R = 2^512)                             
uint32_t Rp[16]  = {0x9df22f0f, 0xddbdba00, 0x2eeb8126, 0x254c6322, 0x5d675825, 0xf59f5cbc, 0x7c88b07e, 0x4be0372b, 0x7d3cf656, 0x089e1128, 0xf70934da, 0x2c82105e, 0xb1869833, 0xa4df0800, 0xbb2e8d48, 0x36f70c86};              
uint32_t Rq[16]  = {0x2c06fd33, 0x8e198d31, 0x090af3b6, 0xcbd8e9e3, 0xaae5daa6, 0xdc5cd4f6, 0x774e7f59, 0xabc96692, 0x09bdf7a4, 0x8d363ab3, 0x2eaa1a6a, 0x6221a643, 0x8d1f9f95, 0xcd24e288, 0x82a99c1b, 0x215ebb58};              
                                                                 
// R^2 mod p, and R^2 mod q, (R = 2^512)                         
uint32_t R2p[16] = {0xa4dc06c0, 0x62415ac9, 0x80e24f2f, 0x0478afb4, 0xa3a4a81b, 0xfe97da5b, 0xf36536b3, 0x16881a21, 0xb14eedde, 0x0d64faad, 0x03961e8a, 0xef375017, 0x3ad6ee04, 0xf27429b7, 0xe49e2914, 0x323d568c};             
uint32_t R2q[16] = {0xf62570b0, 0xc0dadaae, 0xd3136d62, 0x299e4df1, 0x502fb778, 0x22f31453, 0xc31f40a9, 0x2213ed17, 0x40ccd20f, 0x82c12aec, 0x48e232e4, 0x2936871a, 0x02318525, 0x26b08b52, 0xdefa4107, 0x29e71e99};             
                                                                 
// R mod N, and R^2 mod N, (R = 2^1024)                          
uint32_t R_1024[32]  = {0x81e4cd03, 0x517abd25, 0x368ea82b, 0xe9affc0d, 0x33459322, 0xe427b4d9, 0xf853bb0a, 0xa5a93d20, 0x30bada4a, 0x878d477e, 0xda8ec5e8, 0x2a0b8368, 0x392de77d, 0xdaa490ce, 0xe2e17c56, 0x66345ba9, 0xcbc02143, 0x55752944, 0x0fd825ca, 0x4a0d61b7, 0xf90a67aa, 0x007e5215, 0x4cc3911f, 0x12403268, 0x8404e740, 0x6770d7c6, 0x6de97a96, 0xfbe90be2, 0x49df19cf, 0xa7269d0b, 0xcf1dd612, 0x512b9851};     
uint32_t R2_1024[32] = {0x080f55ea, 0xb2978e30, 0x58f47b9a, 0x38217d6a, 0x4656c95e, 0xd6115498, 0x47225902, 0x120de340, 0x27f65ad8, 0x03d8cd0a, 0x676a1a81, 0xd9178c95, 0xf09d28e7, 0x0604ed80, 0x4097b3d8, 0x3e703d67, 0x4ffff3ea, 0x8b3e2004, 0xd5072182, 0x05a7a05e, 0x8b2d6545, 0x22938f23, 0x8c25656b, 0xd8f15db4, 0xe22f06a0, 0xe9b857fe, 0x658b0261, 0xedcfde69, 0x5cf0f09f, 0xb6ae1783, 0x133b9ae0, 0xac3cdd88};     
                                                                 
// One                                                           
uint32_t One[32] = {1,0};                                          