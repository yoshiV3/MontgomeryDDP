#include <stdint.h>                                              
                                                                 
// This file's content is created by the testvector generator    
// python script for seed = 1                    
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
uint32_t M[32] = {0x1e359bd1, 0xd7c45a80, 0xd87536af, 0xf9f398fe, 0xe322c77f, 0xe1522c67, 0x2897fc96, 0xb11a8c06, 0x2ff97c09, 0x2b9d69d6, 0x49e78692, 0x8a8504f5, 0xbd2767f8, 0x84e064ae, 0x02ae56f6, 0xdd774500, 0x489cb7a9, 0xaf8ea80e, 0xf4c166dc, 0xa4cd3859, 0xbee927e7, 0x2b566807, 0x728960b9, 0xa3bc1c91, 0x3b758887, 0x1972ad08, 0x016f44af, 0x25bbea4c, 0x1d7cf775, 0x5f8617c5, 0xda1345c6, 0x81579749};                 
                                                                 
// prime p and q                                                 
uint32_t p[16] = {0x73d29bf9, 0x5883173a, 0x039e791f, 0xb13e8f5a, 0xf7407ee2, 0xad85ae12, 0xc589fe5e, 0xdffc2fff, 0x8eee83c0, 0x633ea75f, 0x07a8b563, 0x1d8f9d96, 0xdda4db3f, 0x8812b4e6, 0x64ab90d5, 0xf6d7b85d};                 
uint32_t q[16] = {0xd52e6fd9, 0x1dd48325, 0x6508f1cc, 0x307cf375, 0x92b10384, 0x558adc79, 0x4058be79, 0x14bd4171, 0x597628f0, 0xfa9367d3, 0xea08115f, 0xc713e09b, 0xea9e0253, 0xa14b5a1d, 0xc27dd42d, 0x86fa1569};                 
                                                                 
// modulus                                                       
uint32_t N[32]       = {0xb2e52d11, 0x8f850a5f, 0x08edfb0c, 0x4f02a1ac, 0xdd070636, 0x6c59cfc8, 0x16a40db7, 0x85bba009, 0x598eba07, 0x5d0fa3cc, 0x32bc6fb5, 0x4aa27cd0, 0x0928454e, 0x027d3081, 0xd1caec35, 0xa98e4223, 0x533983de, 0x36370bb4, 0xe8b0b4c6, 0xfe3655ab, 0x27a4a51e, 0xb403c449, 0xa679cf3b, 0xc1fc4391, 0x884e5080, 0xa65d4d30, 0xcd90ed67, 0x55fcb457, 0x989d6f4c, 0x0303d70e, 0x9a09328e, 0x82260dd0};           
uint32_t N_prime[32] = {0xfb5c9c0f, 0xd3cbec85, 0x3a126c50, 0x0f85259a, 0xb93b900a, 0x89feafbe, 0x30847469, 0x0a87f885, 0x9d5bfa86, 0xec1adae0, 0x448a3dac, 0xa7194e08, 0x61c37198, 0xd5eff8a8, 0xf96efef1, 0x473d83aa, 0xe7c048dd, 0xb1893377, 0xc843e910, 0xcd3b86d2, 0x2119b9dd, 0x6caed27a, 0x7ebcc873, 0x2019cd09, 0x240e3495, 0x040754fb, 0xdfef2830, 0x32a287d7, 0x8e79f7e4, 0x3daeb7e0, 0xbeaeac00, 0x376725cd};     
                                                                 
// encryption exponent                                           
uint32_t e[32] = {0x00008e79};                  
uint32_t e_len = 16;                                             
                                                                 
// decryption exponent, reduced to p and q                       
uint32_t d_p[16] = {0xad73a179, 0x057ece1f, 0x972cc895, 0x8b8d6636, 0x9f808dd9, 0x39ea10a4, 0x2d2698bf, 0x903e93bd, 0xaf210ea2, 0x8fbc1646, 0x026fdb7b, 0x9dd0d64e, 0x1bd4ff20, 0x1e94b72b, 0x8f69b203, 0xd887939f};             
uint32_t d_q[16] = {0xc291dfd1, 0x70d5432d, 0xe0d6926d, 0x20781f34, 0xa2385f7f, 0xbff5f07a, 0xd2660d2b, 0x5ab6b16d, 0x5f3d2738, 0x7d37cf0d, 0x685908f7, 0xb15e14fd, 0x3c212496, 0xe596a54a, 0x7c70fb24, 0x1ee3d90f};             
uint32_t d_p_len =  512;   
uint32_t d_q_len =  509;   
                                                                 
// x_p and x_q                                                   
uint32_t x_p[32] = {0xe3d14b62, 0x23637859, 0xb780c8ee, 0x532153b4, 0xb23ce874, 0xd5a659bf, 0x428174f8, 0x63f49c7a, 0x46ab5139, 0x119b87ea, 0x7f0b56d5, 0xb2ad56c5, 0xb429f001, 0x423e134d, 0x860d2412, 0x20b8db96, 0x418656ea, 0xd27eb87e, 0x66755f3e, 0x840d46a0, 0x08e20ea9, 0xf1813567, 0x7700b305, 0x212e1021, 0x033329fa, 0x8c2be4f6, 0x9f06d473, 0x6292f031, 0x60f0f3af, 0x7104a487, 0x3e0900ba, 0x7b1991a9};             
uint32_t x_q[32] = {0xcf13e1b0, 0x6c219205, 0x516d321e, 0xfbe14df7, 0x2aca1dc1, 0x96b37609, 0xd42298be, 0x21c7038e, 0x12e368ce, 0x4b741be2, 0xb3b118e0, 0x97f5260a, 0x54fe554c, 0xc03f1d33, 0x4bbdc822, 0x88d5668d, 0x11b32cf4, 0x63b85336, 0x823b5587, 0x7a290f0b, 0x1ec29675, 0xc2828ee2, 0x2f791c35, 0xa0ce3370, 0x851b2686, 0x1a31683a, 0x2e8a18f4, 0xf369c426, 0x37ac7b9c, 0x91ff3287, 0x5c0031d3, 0x070c7c27};             
                                                                 
// R mod p, and R mod q, (R = 2^512)                             
uint32_t Rp[16]  = {0x8c2d6407, 0xa77ce8c5, 0xfc6186e0, 0x4ec170a5, 0x08bf811d, 0x527a51ed, 0x3a7601a1, 0x2003d000, 0x71117c3f, 0x9cc158a0, 0xf8574a9c, 0xe2706269, 0x225b24c0, 0x77ed4b19, 0x9b546f2a, 0x092847a2};              
uint32_t Rq[16]  = {0x2ad19027, 0xe22b7cda, 0x9af70e33, 0xcf830c8a, 0x6d4efc7b, 0xaa752386, 0xbfa74186, 0xeb42be8e, 0xa689d70f, 0x056c982c, 0x15f7eea0, 0x38ec1f64, 0x1561fdac, 0x5eb4a5e2, 0x3d822bd2, 0x7905ea96};              
                                                                 
// R^2 mod p, and R^2 mod q, (R = 2^512)                         
uint32_t R2p[16] = {0xfdf10724, 0xe600dae5, 0xf220d081, 0x8d828e78, 0x526e1aca, 0xa84c9a95, 0x62f315c8, 0xb81b5f42, 0x923ce71b, 0x89703f54, 0x9ffce32e, 0x2ff2a8e7, 0x14b005ea, 0xe525b57e, 0x4bfc651d, 0x90c4bd38};             
uint32_t R2q[16] = {0x3c8c1310, 0xbe3865ce, 0x1b7148dc, 0xcd1cad6e, 0x28e96513, 0xcad31eab, 0xe2101d4a, 0xe96da569, 0x2c561e09, 0x7b3c7482, 0xc823ce6d, 0x3561e448, 0xfb424f27, 0x859b1b5d, 0xca8a7792, 0x5dbcce31};             
                                                                 
// R mod N, and R^2 mod N, (R = 2^1024)                          
uint32_t R_1024[32]  = {0x4d1ad2ef, 0x707af5a0, 0xf71204f3, 0xb0fd5e53, 0x22f8f9c9, 0x93a63037, 0xe95bf248, 0x7a445ff6, 0xa67145f8, 0xa2f05c33, 0xcd43904a, 0xb55d832f, 0xf6d7bab1, 0xfd82cf7e, 0x2e3513ca, 0x5671bddc, 0xacc67c21, 0xc9c8f44b, 0x174f4b39, 0x01c9aa54, 0xd85b5ae1, 0x4bfc3bb6, 0x598630c4, 0x3e03bc6e, 0x77b1af7f, 0x59a2b2cf, 0x326f1298, 0xaa034ba8, 0x676290b3, 0xfcfc28f1, 0x65f6cd71, 0x7dd9f22f};     
uint32_t R2_1024[32] = {0xf90fbbef, 0xfde56db5, 0x93970c51, 0xbd4da036, 0x126f841b, 0xcd863350, 0x09395066, 0x41df3394, 0xe026d07d, 0x026cfd9f, 0xb01e631f, 0xe80b06a3, 0x2f70bc6f, 0xbcddad19, 0xed37cd62, 0x61c420c9, 0xb06d0c31, 0x290246bd, 0xd413f733, 0x58dea14b, 0xd9412dd3, 0x61397e6a, 0x9a1f18c4, 0xa6621166, 0x04a49c73, 0x3d485cf9, 0x59e6ba68, 0xcbe937a4, 0x440cdd63, 0x634c0725, 0xe617db95, 0x0aa6db84};     
                                                                 
// One                                                           
uint32_t One[32] = {1,0};                                          