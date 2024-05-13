#!/usr/bin/env ruby

cipher_name = ARGV[0]
if !cipher_name || cipher_name.empty? then
  STDERR.puts "Usage: #{File.basename(__FILE__)} <cipher name>"
  exit 1
end

# Corresponding table on the following page, as of 2024/05/13.
# https://www.openssl.org/docs/man1.0.2/man1/ciphers.html
ciphers_text = <<EOS
SSL_RSA_WITH_NULL_MD5                   NULL-MD5
SSL_RSA_WITH_NULL_SHA                   NULL-SHA
SSL_RSA_EXPORT_WITH_RC4_40_MD5          EXP-RC4-MD5
SSL_RSA_WITH_RC4_128_MD5                RC4-MD5
SSL_RSA_WITH_RC4_128_SHA                RC4-SHA
SSL_RSA_EXPORT_WITH_RC2_CBC_40_MD5      EXP-RC2-CBC-MD5
SSL_RSA_WITH_IDEA_CBC_SHA               IDEA-CBC-SHA
SSL_RSA_EXPORT_WITH_DES40_CBC_SHA       EXP-DES-CBC-SHA
SSL_RSA_WITH_DES_CBC_SHA                DES-CBC-SHA
SSL_RSA_WITH_3DES_EDE_CBC_SHA           DES-CBC3-SHA
SSL_DH_DSS_WITH_DES_CBC_SHA             DH-DSS-DES-CBC-SHA
SSL_DH_DSS_WITH_3DES_EDE_CBC_SHA        DH-DSS-DES-CBC3-SHA
SSL_DH_RSA_WITH_DES_CBC_SHA             DH-RSA-DES-CBC-SHA
SSL_DH_RSA_WITH_3DES_EDE_CBC_SHA        DH-RSA-DES-CBC3-SHA
SSL_DHE_DSS_EXPORT_WITH_DES40_CBC_SHA   EXP-EDH-DSS-DES-CBC-SHA
SSL_DHE_DSS_WITH_DES_CBC_SHA            EDH-DSS-CBC-SHA
SSL_DHE_DSS_WITH_3DES_EDE_CBC_SHA       EDH-DSS-DES-CBC3-SHA
SSL_DHE_RSA_EXPORT_WITH_DES40_CBC_SHA   EXP-EDH-RSA-DES-CBC-SHA
SSL_DHE_RSA_WITH_DES_CBC_SHA            EDH-RSA-DES-CBC-SHA
SSL_DHE_RSA_WITH_3DES_EDE_CBC_SHA       EDH-RSA-DES-CBC3-SHA
SSL_DH_anon_EXPORT_WITH_RC4_40_MD5      EXP-ADH-RC4-MD5
SSL_DH_anon_WITH_RC4_128_MD5            ADH-RC4-MD5
SSL_DH_anon_EXPORT_WITH_DES40_CBC_SHA   EXP-ADH-DES-CBC-SHA
SSL_DH_anon_WITH_DES_CBC_SHA            ADH-DES-CBC-SHA
SSL_DH_anon_WITH_3DES_EDE_CBC_SHA       ADH-DES-CBC3-SHA
SSL_FORTEZZA_KEA_WITH_NULL_SHA          Not implemented.
SSL_FORTEZZA_KEA_WITH_FORTEZZA_CBC_SHA  Not implemented.
SSL_FORTEZZA_KEA_WITH_RC4_128_SHA       Not implemented.
TLS_RSA_WITH_NULL_MD5                   NULL-MD5
TLS_RSA_WITH_NULL_SHA                   NULL-SHA
TLS_RSA_EXPORT_WITH_RC4_40_MD5          EXP-RC4-MD5
TLS_RSA_WITH_RC4_128_MD5                RC4-MD5
TLS_RSA_WITH_RC4_128_SHA                RC4-SHA
TLS_RSA_EXPORT_WITH_RC2_CBC_40_MD5      EXP-RC2-CBC-MD5
TLS_RSA_WITH_IDEA_CBC_SHA               IDEA-CBC-SHA
TLS_RSA_EXPORT_WITH_DES40_CBC_SHA       EXP-DES-CBC-SHA
TLS_RSA_WITH_DES_CBC_SHA                DES-CBC-SHA
TLS_RSA_WITH_3DES_EDE_CBC_SHA           DES-CBC3-SHA
TLS_DH_DSS_EXPORT_WITH_DES40_CBC_SHA    Not implemented.
TLS_DH_DSS_WITH_DES_CBC_SHA             Not implemented.
TLS_DH_DSS_WITH_3DES_EDE_CBC_SHA        Not implemented.
TLS_DH_RSA_EXPORT_WITH_DES40_CBC_SHA    Not implemented.
TLS_DH_RSA_WITH_DES_CBC_SHA             Not implemented.
TLS_DH_RSA_WITH_3DES_EDE_CBC_SHA        Not implemented.
TLS_DHE_DSS_EXPORT_WITH_DES40_CBC_SHA   EXP-EDH-DSS-DES-CBC-SHA
TLS_DHE_DSS_WITH_DES_CBC_SHA            EDH-DSS-CBC-SHA
TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA       EDH-DSS-DES-CBC3-SHA
TLS_DHE_RSA_EXPORT_WITH_DES40_CBC_SHA   EXP-EDH-RSA-DES-CBC-SHA
TLS_DHE_RSA_WITH_DES_CBC_SHA            EDH-RSA-DES-CBC-SHA
TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA       EDH-RSA-DES-CBC3-SHA
TLS_DH_anon_EXPORT_WITH_RC4_40_MD5      EXP-ADH-RC4-MD5
TLS_DH_anon_WITH_RC4_128_MD5            ADH-RC4-MD5
TLS_DH_anon_EXPORT_WITH_DES40_CBC_SHA   EXP-ADH-DES-CBC-SHA
TLS_DH_anon_WITH_DES_CBC_SHA            ADH-DES-CBC-SHA
TLS_DH_anon_WITH_3DES_EDE_CBC_SHA       ADH-DES-CBC3-SHA
TLS_RSA_WITH_AES_128_CBC_SHA            AES128-SHA
TLS_RSA_WITH_AES_256_CBC_SHA            AES256-SHA
TLS_DH_DSS_WITH_AES_128_CBC_SHA         DH-DSS-AES128-SHA
TLS_DH_DSS_WITH_AES_256_CBC_SHA         DH-DSS-AES256-SHA
TLS_DH_RSA_WITH_AES_128_CBC_SHA         DH-RSA-AES128-SHA
TLS_DH_RSA_WITH_AES_256_CBC_SHA         DH-RSA-AES256-SHA
TLS_DHE_DSS_WITH_AES_128_CBC_SHA        DHE-DSS-AES128-SHA
TLS_DHE_DSS_WITH_AES_256_CBC_SHA        DHE-DSS-AES256-SHA
TLS_DHE_RSA_WITH_AES_128_CBC_SHA        DHE-RSA-AES128-SHA
TLS_DHE_RSA_WITH_AES_256_CBC_SHA        DHE-RSA-AES256-SHA
TLS_DH_anon_WITH_AES_128_CBC_SHA        ADH-AES128-SHA
TLS_DH_anon_WITH_AES_256_CBC_SHA        ADH-AES256-SHA
TLS_RSA_WITH_CAMELLIA_128_CBC_SHA      CAMELLIA128-SHA
TLS_RSA_WITH_CAMELLIA_256_CBC_SHA      CAMELLIA256-SHA
TLS_DH_DSS_WITH_CAMELLIA_128_CBC_SHA   DH-DSS-CAMELLIA128-SHA
TLS_DH_DSS_WITH_CAMELLIA_256_CBC_SHA   DH-DSS-CAMELLIA256-SHA
TLS_DH_RSA_WITH_CAMELLIA_128_CBC_SHA   DH-RSA-CAMELLIA128-SHA
TLS_DH_RSA_WITH_CAMELLIA_256_CBC_SHA   DH-RSA-CAMELLIA256-SHA
TLS_DHE_DSS_WITH_CAMELLIA_128_CBC_SHA  DHE-DSS-CAMELLIA128-SHA
TLS_DHE_DSS_WITH_CAMELLIA_256_CBC_SHA  DHE-DSS-CAMELLIA256-SHA
TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA  DHE-RSA-CAMELLIA128-SHA
TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA  DHE-RSA-CAMELLIA256-SHA
TLS_DH_anon_WITH_CAMELLIA_128_CBC_SHA  ADH-CAMELLIA128-SHA
TLS_DH_anon_WITH_CAMELLIA_256_CBC_SHA  ADH-CAMELLIA256-SHA
TLS_RSA_WITH_SEED_CBC_SHA              SEED-SHA
TLS_DH_DSS_WITH_SEED_CBC_SHA           DH-DSS-SEED-SHA
TLS_DH_RSA_WITH_SEED_CBC_SHA           DH-RSA-SEED-SHA
TLS_DHE_DSS_WITH_SEED_CBC_SHA          DHE-DSS-SEED-SHA
TLS_DHE_RSA_WITH_SEED_CBC_SHA          DHE-RSA-SEED-SHA
TLS_DH_anon_WITH_SEED_CBC_SHA          ADH-SEED-SHA
TLS_GOSTR341094_WITH_28147_CNT_IMIT GOST94-GOST89-GOST89
TLS_GOSTR341001_WITH_28147_CNT_IMIT GOST2001-GOST89-GOST89
TLS_GOSTR341094_WITH_NULL_GOSTR3411 GOST94-NULL-GOST94
TLS_GOSTR341001_WITH_NULL_GOSTR3411 GOST2001-NULL-GOST94
TLS_RSA_EXPORT1024_WITH_DES_CBC_SHA     EXP1024-DES-CBC-SHA
TLS_RSA_EXPORT1024_WITH_RC4_56_SHA      EXP1024-RC4-SHA
TLS_DHE_DSS_EXPORT1024_WITH_DES_CBC_SHA EXP1024-DHE-DSS-DES-CBC-SHA
TLS_DHE_DSS_EXPORT1024_WITH_RC4_56_SHA  EXP1024-DHE-DSS-RC4-SHA
TLS_DHE_DSS_WITH_RC4_128_SHA            DHE-DSS-RC4-SHA
TLS_ECDH_RSA_WITH_NULL_SHA              ECDH-RSA-NULL-SHA
TLS_ECDH_RSA_WITH_RC4_128_SHA           ECDH-RSA-RC4-SHA
TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA      ECDH-RSA-DES-CBC3-SHA
TLS_ECDH_RSA_WITH_AES_128_CBC_SHA       ECDH-RSA-AES128-SHA
TLS_ECDH_RSA_WITH_AES_256_CBC_SHA       ECDH-RSA-AES256-SHA
TLS_ECDH_ECDSA_WITH_NULL_SHA            ECDH-ECDSA-NULL-SHA
TLS_ECDH_ECDSA_WITH_RC4_128_SHA         ECDH-ECDSA-RC4-SHA
TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA    ECDH-ECDSA-DES-CBC3-SHA
TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA     ECDH-ECDSA-AES128-SHA
TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA     ECDH-ECDSA-AES256-SHA
TLS_ECDHE_RSA_WITH_NULL_SHA             ECDHE-RSA-NULL-SHA
TLS_ECDHE_RSA_WITH_RC4_128_SHA          ECDHE-RSA-RC4-SHA
TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA     ECDHE-RSA-DES-CBC3-SHA
TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA      ECDHE-RSA-AES128-SHA
TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA      ECDHE-RSA-AES256-SHA
TLS_ECDHE_ECDSA_WITH_NULL_SHA           ECDHE-ECDSA-NULL-SHA
TLS_ECDHE_ECDSA_WITH_RC4_128_SHA        ECDHE-ECDSA-RC4-SHA
TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA   ECDHE-ECDSA-DES-CBC3-SHA
TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA    ECDHE-ECDSA-AES128-SHA
TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA    ECDHE-ECDSA-AES256-SHA
TLS_ECDH_anon_WITH_NULL_SHA             AECDH-NULL-SHA
TLS_ECDH_anon_WITH_RC4_128_SHA          AECDH-RC4-SHA
TLS_ECDH_anon_WITH_3DES_EDE_CBC_SHA     AECDH-DES-CBC3-SHA
TLS_ECDH_anon_WITH_AES_128_CBC_SHA      AECDH-AES128-SHA
TLS_ECDH_anon_WITH_AES_256_CBC_SHA      AECDH-AES256-SHA
TLS_RSA_WITH_NULL_SHA256                  NULL-SHA256
TLS_RSA_WITH_AES_128_CBC_SHA256           AES128-SHA256
TLS_RSA_WITH_AES_256_CBC_SHA256           AES256-SHA256
TLS_RSA_WITH_AES_128_GCM_SHA256           AES128-GCM-SHA256
TLS_RSA_WITH_AES_256_GCM_SHA384           AES256-GCM-SHA384
TLS_DH_RSA_WITH_AES_128_CBC_SHA256        DH-RSA-AES128-SHA256
TLS_DH_RSA_WITH_AES_256_CBC_SHA256        DH-RSA-AES256-SHA256
TLS_DH_RSA_WITH_AES_128_GCM_SHA256        DH-RSA-AES128-GCM-SHA256
TLS_DH_RSA_WITH_AES_256_GCM_SHA384        DH-RSA-AES256-GCM-SHA384
TLS_DH_DSS_WITH_AES_128_CBC_SHA256        DH-DSS-AES128-SHA256
TLS_DH_DSS_WITH_AES_256_CBC_SHA256        DH-DSS-AES256-SHA256
TLS_DH_DSS_WITH_AES_128_GCM_SHA256        DH-DSS-AES128-GCM-SHA256
TLS_DH_DSS_WITH_AES_256_GCM_SHA384        DH-DSS-AES256-GCM-SHA384
TLS_DHE_RSA_WITH_AES_128_CBC_SHA256       DHE-RSA-AES128-SHA256
TLS_DHE_RSA_WITH_AES_256_CBC_SHA256       DHE-RSA-AES256-SHA256
TLS_DHE_RSA_WITH_AES_128_GCM_SHA256       DHE-RSA-AES128-GCM-SHA256
TLS_DHE_RSA_WITH_AES_256_GCM_SHA384       DHE-RSA-AES256-GCM-SHA384
TLS_DHE_DSS_WITH_AES_128_CBC_SHA256       DHE-DSS-AES128-SHA256
TLS_DHE_DSS_WITH_AES_256_CBC_SHA256       DHE-DSS-AES256-SHA256
TLS_DHE_DSS_WITH_AES_128_GCM_SHA256       DHE-DSS-AES128-GCM-SHA256
TLS_DHE_DSS_WITH_AES_256_GCM_SHA384       DHE-DSS-AES256-GCM-SHA384
TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256      ECDH-RSA-AES128-SHA256
TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384      ECDH-RSA-AES256-SHA384
TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256      ECDH-RSA-AES128-GCM-SHA256
TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384      ECDH-RSA-AES256-GCM-SHA384
TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256    ECDH-ECDSA-AES128-SHA256
TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384    ECDH-ECDSA-AES256-SHA384
TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256    ECDH-ECDSA-AES128-GCM-SHA256
TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384    ECDH-ECDSA-AES256-GCM-SHA384
TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256     ECDHE-RSA-AES128-SHA256
TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384     ECDHE-RSA-AES256-SHA384
TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256     ECDHE-RSA-AES128-GCM-SHA256
TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384     ECDHE-RSA-AES256-GCM-SHA384
TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256   ECDHE-ECDSA-AES128-SHA256
TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384   ECDHE-ECDSA-AES256-SHA384
TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256   ECDHE-ECDSA-AES128-GCM-SHA256
TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384   ECDHE-ECDSA-AES256-GCM-SHA384
TLS_DH_anon_WITH_AES_128_CBC_SHA256       ADH-AES128-SHA256
TLS_DH_anon_WITH_AES_256_CBC_SHA256       ADH-AES256-SHA256
TLS_DH_anon_WITH_AES_128_GCM_SHA256       ADH-AES128-GCM-SHA256
TLS_DH_anon_WITH_AES_256_GCM_SHA384       ADH-AES256-GCM-SHA384
TLS_PSK_WITH_RC4_128_SHA                  PSK-RC4-SHA
TLS_PSK_WITH_3DES_EDE_CBC_SHA             PSK-3DES-EDE-CBC-SHA
TLS_PSK_WITH_AES_128_CBC_SHA              PSK-AES128-CBC-SHA
TLS_PSK_WITH_AES_256_CBC_SHA              PSK-AES256-CBC-SHA
SSL_CK_RC4_128_WITH_MD5                 RC4-MD5
SSL_CK_RC4_128_EXPORT40_WITH_MD5        Not implemented.
SSL_CK_RC2_128_CBC_WITH_MD5             RC2-CBC-MD5
SSL_CK_RC2_128_CBC_EXPORT40_WITH_MD5    Not implemented.
SSL_CK_IDEA_128_CBC_WITH_MD5            IDEA-CBC-MD5
SSL_CK_DES_64_CBC_WITH_MD5              Not implemented.
SSL_CK_DES_192_EDE3_CBC_WITH_MD5        DES-CBC3-MD5
EOS

ciphers_list = []
ciphers_text.lines.map(&:strip).each do |cipher_pair|
  next if cipher_pair.empty?
  m  = /^(?<iana_name>\S+)\s+(?<openssl_name>\S.*)$/.match(cipher_pair)
  ciphers_list << [m[:iana_name], m[:openssl_name]]
end

ciphers_list.each do |cipher_pair|
  iana_name, openssl_name = cipher_pair[0], cipher_pair[1]
  if cipher_name == iana_name then
    puts openssl_name
    return
  elsif cipher_name == openssl_name then
    puts iana_name
    return
  end
end

STDERR.puts "Given cipher suite was not found."
exit 1