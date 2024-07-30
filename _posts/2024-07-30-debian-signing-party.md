---
layout: post
title: "Debian signing tool -- caff"
category: debian
---

# Prerequisites

## msmtp
To send the keys. You can refer to the [wiki](https://arnaudr.io/2020/08/24/send-emails-from-your-terminal-with-msmtp/)


TODO: The encryption for the password does not work now. 

## caff

To config `MAILER_SENDER` with `msmtp`.

```
$ENV{'PERL_MAILERS'} = 'sendmail:/usr/bin/msmtp';
```

`.caffrc`:

```bash
vimer@debian:~$ cat ~/.caffrc
# .caffrc -- vim:ft=perl:
# This file is in perl(1) format - see caff(1) for details.

$CONFIG{'owner'} = 'xx';
$CONFIG{'email'} = 'xx@xx';
#$CONFIG{'reply-to'} = 'foo@bla.org';

# You can get your long keyid from
#   gpg --keyid-format long --list-key <yourkeyid|name|emailaddress..>
#
# If you have a v4 key, it will simply be the last 16 digits of
# your fingerprint.
#
# Example:
$CONFIG{'keyid'} = [ qw{954E6A70100598A2} ];
#  or, if you have more than one key:
#   $CONFIG{'keyid'} = [ qw{0123456789ABCDEF 89ABCDEF76543210} ];
#$CONFIG{'keyid'} = [ qw{0123456789ABCDEF 89ABCDEF76543210} ];

# Select this/these keys to sign with
#$CONFIG{'local-user'} = [ qw{0123456789ABCDEF 89ABCDEF76543210} ];

# Additionally encrypt messages for these keyids
#$CONFIG{'also-encrypt-to'} = [ qw{0123456789ABCDEF 89ABCDEF76543210} ];
$ENV{'PERL_MAILERS'} = 'sendmail:/usr/bin/msmtp';

#$CONFIG{'mail-cmd'} = [ 'mutt', '-e', "set from='$CONFIG{owner} <$CONFIG{email}>"   pgp_autoencrypt'
#                                  , '-s', "Your signed PGP key 0x$recipient{keyid}"
#                                 , '-i', $recipient{'template-file'}
#                                , '-a', $recipient{'signature-file'}
#                               , '--'
#                              , $recipient{address} ]

# Mail template to use for the encrypted part
$CONFIG{'mail-template'} = << 'EOM';
Hi,

please find attached the user id{(scalar @uids >= 2 ? 's' : '')}
{foreach $uid (@uids) {
    $OUT .= "\t".$uid."\n";
};}of your key {$key} signed by me.

If you have multiple user ids, I sent the signature for each user id
separately to that user id's associated email address. You can import
the signatures by running each through `gpg --import`.

Note that I did not upload your key to any keyservers. If you want this
new signature to be available to others, please upload it yourself.
With GnuPG this can be done using
        gpg --keyserver hkp://pool.sks-keyservers.net --send-key {$key}

If you have any questions, don't hesitate to ask.

Regards,
--
{$owner}
EOM
```
