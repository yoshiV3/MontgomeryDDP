#include <stdint.h>                                              
                                                                 
// This file's content is created by the testvector generator    
// python script for seed = 2019
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
uint32_t M[32] = {0x1936648a, 0x49e241dd, 0xeaf6ade6, 0x5fbcd012, 0x1d48b49d, 0xb9a963ee, 0x0dfb879a, 0xeb4e7d78, 0x841b12dd, 0x6f4eeabe, 0xbcb0a7d9, 0xd529a6de, 0x3cc14403, 0x3df0d0e5, 0x993c5848, 0xf73529a9, 0x69414305, 0x1e8a2cd7, 0xd9a3ec6f, 0x05dbca1e, 0x45ac2540, 0x632b7f1c, 0xa29000eb, 0x6954947f, 0xa6bac1fe, 0x664d8d08, 0xa3a471bf, 0x94e0bb41, 0x26f58ca3, 0xec5dc0de, 0xce757911, 0x99e11894};
                                                                 
// prime p and q                                                 
uint32_t p[16] = {0x0575f93f, 0x67d76608, 0x46a9eb98, 0x7c7be880, 0xa21a59b0, 0xbec3f67d, 0xcc4e6d46, 0x08a0ce1e, 0xe4931d37, 0x85bef62b, 0x504f830f, 0x3af4dc98, 0xb3a61c56, 0x18f843cb, 0xc9a0fc8f, 0xc3950043};
uint32_t q[16] = {0x4c7cf7cf, 0xf1b8fa22, 0x61aaa8e0, 0x21c07166, 0xaf71acb4, 0x481a8198, 0x644d14b1, 0x46f290be, 0xa38e693e, 0x1daf1a6c, 0xa28e0551, 0x63b2b88e, 0x2185d747, 0x1d104496, 0x326a87f4, 0xdb195a7b};
                                                                 
// modulus                                                       
uint32_t N[32]       = {0xac6452f1, 0xfb798942, 0x0f249901, 0x5babf628, 0x7b289988, 0x9b0be47a, 0x20a8c13d, 0x30edb1b2, 0x32df5d0d, 0x2c6ac4f1, 0x61f43828, 0x5ee58557, 0x1b61dc4c, 0x772a3783, 0xb782a039, 0x1226f07d, 0x90961184, 0x3b53e965, 0x932d242f, 0x1201ed0c, 0x5ecb0bc7, 0x1ce6ab19, 0xad318f92, 0x24f30dab, 0x572370a9, 0x4861dc4f, 0xca484f1a, 0x478d60b2, 0xba834df4, 0xfa48b670, 0x854edbd8, 0xa763d5e7};
uint32_t N_prime[32] = {0xdefda1ef, 0x7c5ffb73, 0xd5a6f809, 0x0f812315, 0x2a693b12, 0xc54a47b1, 0x6e816600, 0x97551771, 0xe851f7f4, 0x739b5800, 0xa385125c, 0x5bbf7193, 0xa6e8cf36, 0x1adcf8e3, 0x8f9981f8, 0x1a833f93, 0x22d26149, 0xcc8db2fd, 0x61f127ef, 0x0c70cb1e, 0x21c009e5, 0x70cd184e, 0xb1d43815, 0x14bedb8b, 0x6d3f7b9c, 0x3624f511, 0x59c51283, 0x65352aed, 0x7b0d1201, 0x65ab7c87, 0x6b99003b, 0x6f11bf30};
                                                                 
// encryption exponent                                           
uint32_t e[32] = {0x0000975b};
uint32_t e_len = 16;                                             
                                                                 
// decryption exponent, reduced to p and q                       
uint32_t d_p[16] = {0x740d37ab, 0x62dab2b0, 0xa455cb65, 0x3db2caf4, 0x9fa1c886, 0x2749f1ce, 0xdc62d4a3, 0x842d5b1a, 0x2434da88, 0x3c3ac3bf, 0x11d8a5e5, 0x9cbfc780, 0x454fd7e1, 0x321f5960, 0x4dbadfc6, 0x123b7034};
uint32_t d_q[16] = {0x6b5b17cf, 0xb4392e51, 0xe9188785, 0x11fa7af9, 0x5dcdc0cb, 0x419c8d74, 0x2d1a0c7b, 0xc2758782, 0xe353ac96, 0x3673f111, 0xbe29de6e, 0x7cddbdad, 0xb459b564, 0xa3fdccfc, 0xbdd0c53d, 0xd163dc1f};
uint32_t d_p_len =  509;
uint32_t d_q_len =  512;   
                                                                 
// x_p and x_q                                                   
uint32_t x_p[32] = {0x41a05456, 0xd88fa13d, 0xd2ab4226, 0x0e58040b, 0xa55ecc8e, 0x6933f417, 0xb7d9b91a, 0xaf550f8c, 0xf583eda1, 0x1add9080, 0x5834be45, 0xacbb1422, 0x5228ca18, 0xe3bb66d9, 0x6f00866e, 0x02b10578, 0x2476a8eb, 0x12c8161b, 0xfbbedfc6, 0x4ede159e, 0x37c88db8, 0x199f33df, 0x44b60c51, 0x604a703f, 0xc1c5bedc, 0xf907226a, 0x4a2fc041, 0x5fbc421b, 0x6ee94fd5, 0x5d17bcc8, 0x3d63e776, 0x3e13237c};
uint32_t x_q[32] = {0x6ac3fe9c, 0x22e9e805, 0x3c7956db, 0x4d53f21c, 0xd5c9ccfa, 0x31d7f062, 0x68cf0823, 0x8198a225, 0x3d5b6f6b, 0x118d3470, 0x09bf79e3, 0xb22a7135, 0xc9391233, 0x936ed0a9, 0x488219ca, 0x0f75eb05, 0x6c1f6899, 0x288bd34a, 0x976e4469, 0xc323d76d, 0x27027e0e, 0x0347773a, 0x687b8341, 0xc4a89d6c, 0x955db1cc, 0x4f5ab9e4, 0x80188ed8, 0xe7d11e97, 0x4b99fe1e, 0x9d30f9a8, 0x47eaf462, 0x6950b26b};
                                                                 
// R mod p, and R mod q, (R = 2^512)                             
uint32_t Rp[16]  = {0xfa8a06c1, 0x982899f7, 0xb9561467, 0x8384177f, 0x5de5a64f, 0x413c0982, 0x33b192b9, 0xf75f31e1, 0x1b6ce2c8, 0x7a4109d4, 0xafb07cf0, 0xc50b2367, 0x4c59e3a9, 0xe707bc34, 0x365f0370, 0x3c6affbc};
uint32_t Rq[16]  = {0xb3830831, 0x0e4705dd, 0x9e55571f, 0xde3f8e99, 0x508e534b, 0xb7e57e67, 0x9bb2eb4e, 0xb90d6f41, 0x5c7196c1, 0xe250e593, 0x5d71faae, 0x9c4d4771, 0xde7a28b8, 0xe2efbb69, 0xcd95780b, 0x24e6a584};
                                                                 
// R^2 mod p, and R^2 mod q, (R = 2^512)                         
uint32_t R2p[16] = {0x429509c9, 0x402eea71, 0x6bd7dcc7, 0xb246d946, 0x1115bf2a, 0x15caa3db, 0x1763a24f, 0x4ecc398d, 0xd9ca362e, 0x63a77c32, 0xb4e47b1d, 0x7c4e2255, 0x15c807af, 0x3d246ea3, 0xbaea4555, 0x39ca2753};
uint32_t R2q[16] = {0xf254797c, 0x1b223492, 0xf2819ed5, 0xd95f8589, 0xcbbc30a2, 0x5a5bb6da, 0x79d9f297, 0x59cad784, 0xfe2255b3, 0xa0c923a7, 0x39bdaba2, 0x9bb1b88d, 0x516faf34, 0x4157c768, 0x800d3990, 0x4c759fae};
                                                                 
// R mod N, and R^2 mod N, (R = 2^1024)                          
uint32_t R_1024[32]  = {0x539bad0f, 0x048676bd, 0xf0db66fe, 0xa45409d7, 0x84d76677, 0x64f41b85, 0xdf573ec2, 0xcf124e4d, 0xcd20a2f2, 0xd3953b0e, 0x9e0bc7d7, 0xa11a7aa8, 0xe49e23b3, 0x88d5c87c, 0x487d5fc6, 0xedd90f82, 0x6f69ee7b, 0xc4ac169a, 0x6cd2dbd0, 0xedfe12f3, 0xa134f438, 0xe31954e6, 0x52ce706d, 0xdb0cf254, 0xa8dc8f56, 0xb79e23b0, 0x35b7b0e5, 0xb8729f4d, 0x457cb20b, 0x05b7498f, 0x7ab12427, 0x589c2a18};
uint32_t R2_1024[32] = {0x078119bc, 0x9b02a75f, 0x9aa18d79, 0x5eb22bdd, 0x8f98b69f, 0x8ff41d97, 0x6db71acf, 0x632edb39, 0x98eef74b, 0x26b1efae, 0x2c4a950d, 0x69d9058b, 0xd80b9f87, 0x6a9b7fa9, 0xfcd7df63, 0xbad38c66, 0xfebe04fb, 0xcc928bc2, 0x1655af13, 0xce4fe939, 0xa9dc423c, 0x708e986d, 0x0a71556e, 0x4d8e6f12, 0xbcdb4299, 0xd6cfd1d0, 0xcc87bc60, 0x7772f356, 0x941ccd8f, 0x8fcc217a, 0x3903a612, 0x0694395f};
                                                                 
// One                                                           
uint32_t One[32] = {1,0};



