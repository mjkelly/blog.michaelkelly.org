---
title: 'Sending SMS alerts when the power goes out with apcupsd and Amazon SNS or Plivo'
date: 2013-12-28T18:22:00.001-05:00
draft: false
url: /2013/12/sending-sms-alerts-when-power-goes-out.html
---

_\[Edited 2014-08-09 to add mention of Plivo (and pointer to sample script), and mention the NOLOGINDIR in the default Debian config.\]_

This post recounts how I set up SMS alerts to tell me when the power went out in my apartment. I set it up on a Debian testing box. It's very simple. (And you get to use **_the cloud_**, whatever that is!) Note that none of this will work if your ISP's networking gear is dead too! This probably won't protect you against a widespread mains outage, unless you're on DSL, or your ISP really cares.

I haven't tested it in a real power outage yet, and I haven't tested suitability of SNS for this kind of use-case. If you care a lot about this working, go read someone else's instructions.

Building blocks:

*   An APC uninterruptible power supply that powers to your server and any networking gear the server needs. (In my case: dumb switch, and firewall. The cable modem has its own battery, inexplicably.)
*   An Amazon Web Services account. We'll be using SNS. **OR**, a [Plivo](http://plivo.com) account. (Plivo is much simpler.)
*   A phone that can receive text messages. If you're using Amazon, it must be able to receive text messages from shortcodes. (That means **no Google Voice if you're using Amazon**. As of 2013-12-28 I confirmed that it cannot receive text messages from Amazon's shortcode, 30304.)
*   A linux server. It needs some software:
    *   The [AWS CLI](http://aws.amazon.com/cli/), if you're going to use Amazon to send notifications; **OR**, the [plivo python module](https://www.plivo.com/docs/helpers/python/), if you're going to use Plivo to send notifications.
    *   [apcupsd](http://www.apcupsd.org/). Note the warnings on their page about UPS compatibility. I used a Back-UPS RS 1300G and it worked fine.

**Plivo vs Amazon**

Plivo is much simpler to set up. However, you must rent a dedicated phone number from them for $0.80/mo (as of Aug 2014), and there is no "subscriber" model like Amazon, which means you must send text messages to each recipient individually.

It depends on what you want. I only want to message myself (1 number) when something happens, and I use Google Voice -- so Plivo is a better fit for me.

**Plivo Setup**

(Skip if you're using Amazon.)

No detailed instructions, but it is not complicated: go to [plivo.com](http://plivo.com) and sign up for a phone number.

This is the script I wrote to send text messages -- it is just a simple modification of one of Plivo's examples. I put calls to this script in the event scripts in `/etc/apcupsd/`: [plivo-sms.py](https://github.com/mjkelly/experiments/blob/master/power/plivo-sms.py).

**Amazon SNS Setup**

(Skip if you're using Plivo.)

Create a new topic in SNS. Note that it is uniquely identified by a string that Amazon calls an ARN. Add an SMS subscriber, and enter your phone number. Wait for the confirmation text message on your phone, and confirm. You may wish to also add an email subscriber.

Verify: Send a notification from the SNS console, by hitting the "Publish" button.

**Amazon SNS Client Setup**

(Skip if you're using Plivo.)

You'll have to be able to publish to SNS from the command-line. Set up a new user by going to the [Security Credentials](https://console.aws.amazon.com/iam/home#users) page. Create a new user. Note the credentials amazon has generated.

Add permissions to the new user so it may publish to the SNS topic you created before.

I gave my user "Publish" permissions to all my SNS ARNs, since I'm using SNS exclusively for this exercise. You can craft these permissions in the interface by clicking on your user -> Permissions tab -> Add User Policy -> Policy Generator. You can also select Custom Policy and paste in the following policy:

```
{
  "Version": "2012-10-17",
  "Statement": \[
    {
      "Sid": "Stmt138826832300",
      "Effect": "Allow",
      "Action": \[
        "sns:Publish"
      \],
      "Resource": \[
        "\*"
      \]
    }
  \]
}

```Install the [Amazon command-line interface](http://aws.amazon.com/cli/). Because we'll be calling aws from apcupsd, configure aws as the root user:```
\# aws configure

```

Enter the credentials you created before. I picked the region my SNS topic is in as my default region.

Verify: Test sending a notification from the command line with aws sns publish (substitute the ARN of your SNS topic for _your\_arn_ below):

```
\# aws sns publish --topic-arn=_your\_arn_ --message="something happened on ${HOSTNAME}"

```

You should get a text message!

**apcupsd Setup**

Install apcupsd via your package manager. Configure it for your UPS by editing /etc/apcupsd/apcupsd.conf. **Two notes for Debian**, (1) comment out the line "`#NOLOGINDIR /etc`" unless you want apcupsd to prevent logins after a power failure, and (2) you must subsequently edit /etc/default/apcupsd to set ISCONFIGURED=yes and manually start the service.

Check that it can talk to your UPS by running apcaccess.

There are interesting configuration files in /etc/apcupsd -- they define what happens on various power events. The relevant one here is /etc/apcupsd/onbattery, which is run when the UPS switches to battery power. With apcupsd 3.14.10, the file looks like this (comments stripped out):

```
SYSADMIN=root
APCUPSD\_MAIL="mail"

HOSTNAME=\`hostname\`
MSG="$HOSTNAME Power Failure !!!"

(
   echo "Subject: $MSG"
   echo " "
   echo "$MSG"
   echo " "
   /sbin/apcaccess status
) | $APCUPSD\_MAIL -s "$MSG" $SYSADMIN
exit 0

```

I edited the file to add the bold text below (again, substitute the ARN of your SNS topic for _your\_arn_):

```
SYSADMIN=root
APCUPSD\_MAIL="mail"

HOSTNAME=\`hostname\`
MSG="$HOSTNAME Power Failure !!!"

(
   echo "Subject: $MSG"
   echo " "
   echo "$MSG"
   echo " "
   /sbin/apcaccess status
) | $APCUPSD\_MAIL -s "$MSG" $SYSADMIN
 **# either amazon SNS script or plivo script follows:
aws sns publish --topic-arn=_your\_arn_ \\
        --subject="${MSG}" \\
        --message="${MSG}"
# or: /path/to/plivo-sms.py "${MSG}"**
exit 0

```

I just use the subject line because text messages must be short. I figure the hostname will give plenty of context.

(If you've set up your mail daemon so mail can send messages to non-local addresses, you may wish to change the value of SYSADMIN to your email address as well. Note that doing that **and** adding your email address to the SNS topic will result in duplicate emails -- one verbose, one short.)

Restart the apcupsd service.

Verify: Pull the plug of your UPS out of the wall! You should get an anxious message from apcupsd.

**Final Notes**

Again, none of this will work if your ISP's networking gear is dead too! This probably won't protect you against a widespread power outage.

apcupsd is by default configured to shut down the machine when the UPS' battery has 5% or 3 minutes remaining.