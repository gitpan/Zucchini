package Zucchini;
# vim: ts=8 sts=4 et sw=4 sr sta
use strict;
use warnings;

use Zucchini::Version; our $VERSION = $Zucchini::VERSION;
use Zucchini::Config;
use Zucchini::Fsync;
use Zucchini::Rsync;
use Zucchini::Template;

# object attributes
my %config_of :ATTR( get => 'config', set => 'config' );

use Class::Std;
{
    sub BUILD {
        my ($self, $obj_ID, $arg_ref) = @_;

        # set our config to be a new Zucchini::Config object
        # instantiated with the arguments passed to ourself
        $self->set_config(
            Zucchini::Config->new(
                $arg_ref
            )
        );

        return;
    }

    sub gogogo {
        my $self = shift;

        # if we're not rsync-only or fsync-only, we should perform the
        # template processing
        if (
            not (
                $self->get_config->is_rsync_only()
                    or 
                $self->get_config->is_fsync_only()
            )
        ) {
            $self->process_templates;
        }
        # let verbose people know we're *NOT* processing any templates
        else {
            if ($self->get_config->verbose) {
                warn "Skipping template processing phase\n";
            }
        }


        # was a remote-sync requested?
        if (
            $self->get_config->is_rsync()
                or 
            $self->get_config->is_rsync_only()
        ) {
            $self->remote_sync;
        }

        # was an ftp-sync requested?
        if (
            $self->get_config->is_fsync()
                or 
            $self->get_config->is_fsync_only()
        ) {
            $self->ftp_sync;
        }
    }

    sub process_templates {
        my $self = shift;
        my ($templater);

        # create a new templater object
        $templater = Zucchini::Template->new(
            {
                config => $self->get_config,
            }
        );
        # process the site
        $templater->process_site;

        return;
    }

    sub ftp_sync {
        my $self = shift;
        my ($fsyncer);

        # create a new fsync object
        $fsyncer = Zucchini::Fsync->new(
            {
                config => $self->get_config,
            }
        );
        # process the site
        $fsyncer->ftp_sync;

        return;
    }

    sub remote_sync {
        my $self = shift;
        my ($rsyncer);

        # create a new rsync object
        $rsyncer = Zucchini::Rsync->new(
            {
                config => $self->get_config,
            }
        );
        # process the site
        $rsyncer->remote_sync;

        return;
    }
};

1;

__END__

=pod

=head1 NAME

Zucchini - turn templates into static websites

=head1 DESCRIPTION

TODO

=head1 SYNOPSIS

TODO

=head1 SEE ALSO

L<Zucchini::Config>,
L<Zucchini::Fsync>,
L<Zucchini::Rsync>,
L<Zucchini::Template>

=head1 AUTHOR

Chisel Wright C<< <chiselwright@users.berlios.de> >>

=head1 LICENSE

Copyright 2008 by Chisel Wright

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

See <http://www.perl.com/perl/misc/Artistic.html>

=cut
