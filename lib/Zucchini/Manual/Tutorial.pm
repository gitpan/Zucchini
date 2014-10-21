package Zucchini::Manual::Tutorial;
# vim: ts=8 sts=4 et sw=4 sr sta
use strict;
1;

__END__

=pod

=head1 NAME

Zucchini::Manual::Tutorial - simple website example

=head1 DESCRIPTION

This tutorial will guide you through the process of setting up a simple
website using Zucchini.

=head1 ASSUMPTIONS

For the purposes of this tutorial it is assumed that you have a user on your
system with the username C<zuke>.

C<zuke> is assumed to have never run C<zucchini> before.

C<zuke> should have sudo super-powers for the initial directory configuration.

=head1 SETTING UP

=head2 Local Website Source

Firstly we will create the area in which the website templates are created.

  mkdir -p $HOME/sites/zuke/{templates,includes}

=head2 Local Website Output

We also require somewhere for the generated output to live. We'll keep our
(local) website sources somewhere easy to find, rather than hidden away in
C<zuke>'s home directory.

  sudo mkdir -p /var/www/zuke/{html,log}
  sudo chown -R zuke:www-data /var/www/zuke

=head2 Adding an apache2 virtualhost

This step is optional, but provides a convenient way to view and verify the
site before uploading it to the remote (live) server.

Configuring apache2 is beyond the scope of this tutorial.  In a nutshell, make
sure you are configured to use C<< <VirtualHost> >>s and add the following
block to your configuration:

  <VirtualHost www_zuke.private.somedomain.co.uk>
    ServerAdmin     zuke@localhost
    ServerName      www_zuke.private.somedomain.co.uk

    DocumentRoot    /var/www/zuke/html
    ErrorLog        /var/www/log/error_log
    CustomLog       /var/www/log/access_log common

    <Directory /var/www/zuke/html>
      Options Indexes FollowSymLinks MultiViews
      AllowOverride None
      Order allow,deny
      allow from all
    </Directory>
  </VirtualHost>

You'll also require a tweak to your local hosts file to recognise the hostname
used:

  sudo sh -c \
    'echo "127.0.1.77 www_zuke.private.somedomain.co.uk www_zuke" \
        >> /etc/hosts'

You should now restart apache2 for the changes to take effect.

=head3 Debian/Ubuntu

Debian/Ubuntu users can paste the VirtualHost block above into a new file in
/etc/apache2/sites-enabled/ and use C<a2ensite>:

  sudo $EDITOR /etc/apache2/sites-available/zuke
  # paste in VirtualHost block
  sudo a2ensite zuke
  sudo /etc/init.d/apache2 restart

=head2 Configuring Zucchini

It's possible to build a C<.zucchini> configuration file from scratch. Most
people find it easier to have a working example to copy and modify.

We'll start by creating a default configuration file, and ammend it to process
the new site we're building.

  zucchini --create-config

If all goes well, you will see no output on your screen. A new file should
have been written to your home directory:

  $ ls -l $HOME/.zucchini
  -rw-r--r-- 1 zuke zuke 1956 2008-05-20 08:39 /home/zuke/.zucchini

Running C<zucchini> now will result in errors about a missing site
configuration and the script will terminate.

We'll add a new section for our new site.

  $EDITOR $HOME/.zucchini

Alter

  default_site  default

to read

  default_site  zuke

Also, after the C<< <site> >> opening tag add:

  <zuke>
    source_dir          /home/zuke/sites/zuke/templates
    includes_dir        /home/zuke/sites/zuke/includes
    output_dir          /var/www/zuke/html

    template_files      \.html\z
    ignore_dirs         CVS
    ignore_dirs         \.svn
    ignore_files        \.swp\z

    <tags>
      author            Zuke Hini
      copyright         &copy; 2006-2008 Zuke Hini. All rights reserved.
    </tags>
  </zuke>

We're now ready to rock and roll!

=head1 CREATING A NEW SITE

This section takes you through the first steps in creating the source files
for a new webite.

=head2 Generating the website

C<zucchini> is configured for our new site. There's one slight problem; we
don't have anything to generate the site from.

Time to rectify this oversight!

Let's start by creating a shared header and footer for all of the pages we
will create.

=head3 includes/header.tt

Create a new header file:

  $EDITOR $HOME/sites/zuke/includes/header.tt

and add the following HTML markup to it:

  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
  <html>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      <title>[% author %]'s Site</title>
    </head>
    <body>

Save the file and exit the editor.

=head3 includes/footer.tt

Create a new footer file:

  $EDITOR $HOME/sites/zuke/includes/footer.tt

and add the following HTML markup to it:

      <p>[% copyright %]</p>
    </body>
  </html>

Save the file and exit the editor.

=head3 templates/index.html

We'll now create the main index.html page for the site.
Create the new file:

  $EDITOR $HOME/sites/zuke/templates/index.html

and add the following to it:

  [% PROCESS header.tt %]

  <h1>[% author %]'s Main Page</h1>

  <p>It's simple, but it works</p>

  [% PROCESS footer.tt %]

Save the file and exit the editor.

For the curious, C<[% PROCESS ... %]> is
L<Template::Toolkit|Template Toolkit>'s way of including other files into the
current file.

=head3 Invoke zucchini

Now that we have some source files we can ask zucchini to work its magic for
us.

As this is our first time with it, we'll ask it to tell us more about what
it's doing.

Run the following command in your terminal:

  zucchini --showdest --showpath

You should see the following output:

  templating: index.html
    --> /var/www/zuke/html/index.html

If you look at C</var/www/zuke/html/index.html> you'll see that our three
files have been glued together into one HTML file.

Assuming you've set up your webserver as described earlier in the tutorial you
can also visit L<http://www_zuke/> in your browser to view the page.

=head3 tag magic

Some of you may already have noticed that we snuck some voodoo into two of the
files we created for the site source:

  <title>[% author %]'s Site</title>

and
  <h1>[% author %]'s Main Mage</h1>

and also

  <p>[% copyright %]</p>

As a rule, anything of the form C<[% ... %]> is
L<Template::Toolkit|Template Toolkit>
markup. At the most basic level, it's used to include other files, and to
insert user-defined variables into documents.

C<author> and C<copyright> are both defined in the C<< <tags> >> section of
the configuration block for our site.

C<[% author %]> means: insert the value we assigned to C<author> here.

=head3 templates/about.html

A one-page site is pretty easy to maintain without Zucchini, so we'll add
a second page to the site to demonstrate Zuchini further.

We'll now create the main index.html page for the site.
Create the new file:

  $EDITOR $HOME/sites/zuke/templates/about.html

and add the following to it:

  [% PROCESS header.tt %]

  <h1>About [% author %]'s Site</h1>

  <p>This site was created with the help of Zucchini</p>

  <p>Head back to the <a href="/">main page</a></p>

  [% PROCESS footer.tt %]

Regenerate the site:

  zucchini --showdest --showpath

You should see the following output:

  templating: about.html
    --> /var/www/zuke/html/about.html

Visit L<http://www_zuke/about.html> in your browser to view the page.

A couple of things that you should note here: 

=over 4

=item *

only the newly added page was processed

This is intentional. There's rarely any need to re-process unchanged
templates. If you do need to regenerate the entire site use C<--force>

=item *

the URL for the main page was I<absolute not relative>

There's nothing stopping you from using relative URLs. It's nearly always
easier, and clearer, to use absolute URLs.

=back

=head3 templates/images/icons/index.png

We'll add an image to the site to demonstrate to non-template files.

We'll create a directory for icons to live in, and then copy an apache2 icon
into the directory.

If C</usr/share/apache2/icons/index.png> doesn't exist, please replace it with
the path to any image of your choosing.

  mkdir -p $HOME/sites/zuke/templates/images/icons/
  cp /usr/share/apache2/icons/index.png \
     $HOME/sites/zuke/templates/images/icons/

Regenerate the site:

  zucchini --showdest --showpath

You should see the following output:

  output directory '/var/www/zuke/html/images' does not exist
  created: /var/www/zuke/html/images
  output directory '/var/www/zuke/html/images/icons' does not exist
  created: /var/www/zuke/html/images/icons
  Copying: images/icons/index.png
    --> /var/www/zuke/html/images/icons/index.png

Zucchini automatically creates required directories in the output location,
then I<copies> the non-template file into the correct location.

Zucchini treats all non-template files in this manner. If you would like more
files to be treated as templates, edit your C<.zucchini> configuration file
and add more C<template_files> options:

  # treat txt files as templates
  template_files    \.txt\z

As with template files, unmodified files will not be processed unless they
have been modified.

=head2 Regenerate everything

There are times when you may wish to re-process the entire site. Often this is
because you have edited a file in the C<includes/> directory and wish the
modification to be applied across the site.

(For various reasons altering an C<includes/> file will not trigger the
regeneration of files in C<templates/> that C<[% PROCESS %]> or
C<[% INCLUDE %]> them)

Simply use the C<--force> option and modification inforation will be ignored:

=head2 Transferring Files

There are two methods available for transferring files to your remote web
server: rsync and ftp.

B<Before using either method> please ensure that you have a working backup
of your site. Both methods have been extensively used by the author but he's
always worried that he's overlooked something important that does bad things
during the upload phase.

=head3 Transferring via rsync

If you're really lucky you'll have ssh access to your server. If you do, you
can use the C<--rsync> option to transfer your site to the remote server.

You'll need to add the following inside the C<< <zuke> ... </zuke> >> block in
your configuration file:

  <rsync>
    hostname        localhost
    path            /home/zuke/rsync-test
  </rsync>

You should change the values to match your own situation.

To transfer files after re-processing:

  zucchini --showdest --showpath --rsync

=head3 Transferring via fsync

Most of the time you will be limited to ftp for transferring files to your
server. Because transferring the entire site would be boring, time-consuming
and wasteful of bandwidth Zucchini implements a form of poor-man's rsync.

I<fsync> uses files in the local output directory and on the remote server to
track files and whether or not they have been modified. (digest.md5)

It will only transfer files that exist locally and appear to have changed
since the last transfer using fsync.

You'll need to add the following inside the C<< <zuke> ... </zuke> >> block in
your configuration file:

  <ftp>
    hostname       localhost
    username       zucchini
    password       courgette
    passive        1
    path           /zuke
  </ftp>

Once again, change the values to match your own situation - transferring files
via FTP to the machine you are transferring files from is almost definitely
not the behaviour you require.

I<passive> and  I<path> are both optional values, but it's better to be
explicit.

To transfer files after re-processing:

  zucchini --showdest --showpath --fsync --verbose

Which should result in the following output:

  No remote digest
  checking remote directories...
  MKDIR /zuke/images
  MKDIR /zuke/images/icons
  transferring files...
  PUT about.html about.html
  PUT index.html index.html
  PUT images/icons/index.png images/icons/index.png
  PUT digest.md5

The first time you use C<--fsync> for a site it will I<always> transfer all
files; the remote file it uses for comparison won't yet exist.

Once you're happy that C<--fsync> is Doing The Right Thing you can omit the
C<--verbose> option. As ftp is a frustrating protocol to use, it's often
better to use C<--verbose> and keep an eye on it.

If things go terribly wrong C<--ftp-debug> will throw even more information
onto your screen.

=head1 SEE ALSO

L<Zucchini> - the top-level project module

L<Template::Manual::Intro> - an introduction to the templating system

=head1 AUTHOR

Chisel Wright C<< <chiselwright@users.berlios.de> >>

=head1 LICENSE

Copyright 2008 by Chisel Wright

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

See <http://www.perl.com/perl/misc/Artistic.html>

=cut
