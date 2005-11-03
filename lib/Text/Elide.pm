package Text::Elide;

use version; $VERSION = qv('0.0.2');

use warnings;
use strict;
use Carp;

use base qw( Exporter );
our @EXPORT_OK = qw( elide );

# use Smart::Comments;
use Readonly;
use List::Util qw( min );

Readonly my $elision => " ...";

# Module implementation here

sub elide
{
    defined( my $string = shift ) || die "no string argument\n";
    defined( my $length = shift ) || die "no length argument\n";
    croak "length must be a positive integer\n" unless $length > 0;
    return $string if length( $string ) <= $length;
    ### require: length( $string ) > $length
    my $lookahead = substr( $string, $length, 1 );
    ### require: length( $lookahead ) == 1
    $string = substr( $string, 0, $length );
    ### require: length( $string ) == $length
    return $string if $lookahead =~ /\s/;
    ### require: $lookahead =~ /\S$/
    $string =~ s/\s*$//;
    ### require: $string =~ /\S$/
    return $string unless $string =~ /\s/;
    ### require: $string =~ /\s/
    $string =~ s/\s*\S+$//;
    ### require: $string =~ /\S$/
    my $padding = $length - length( $string );
    return $string unless $padding >= length( $elision );
    ### require: $padding >= length( $elision )
    $string = $string . $elision;
    ### require: length( $string ) <= $length
    return $string;
}

1; # Magic true value required at end of module
__END__

=head1 NAME

Text::Elide - Perl module with simple "word" aware string truncating routine

=head1 VERSION

This document describes Text::Elide version 0.0.1

=head1 SYNOPSIS

    use Text::Elide qw( elide );
    # text is "testing testing"
    my $new_text = elide( $text, 11 );
    # new_text is "testing ..."

=head1 DESCRIPTION

This is a simple module that exports a single function - elide - which takes a string and a length and truncates the string to at most the length given. It does this is a way which is "word" aware, so that you always end up with a string that only has complete words, and the elision string is only inserted if there is room for it. A word here simply means non-whitespace (\S+). The default elision string is " ...".  The only exception to the complete word condition is if there is only one word (i.e. no whitespace).

Here are some example inputs /outputs:

    elide( "testing testing testing", 15 );     # "testing testing",
    elide( "testing testing testing", 14 );     # "testing ...",
    elide( "testing testing", 11 );             # "testing ...",
    elide( "testing testing", 10 );             # "testing",
    elide( "testing testing", 9 );              # "testing",
    elide( "testing testing", 8 );              # "testing",
    elide( "testing testing", 7 );              # "testing",
    elide( "testing testing", 6 );              # "testin",

=head1 INTERFACE 

=head2 elide( string, length )

This function return a string less than or equal to length, with appropriate truncation / elision.

=head1 DIAGNOSTICS

=over

=item C<< length must be a positive integer >>

This error will occur if you try to pass a length that evaluates in numeric context to a value less than or equal to zero.

=back

=head1 CONFIGURATION AND ENVIRONMENT

Text::Elide requires no configuration files or environment variables.

=head1 DEPENDENCIES

Readonly, List::Util, Test::More

=head1 SEE ALSO

Text::Truncate, String::Truncate

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-text-elide@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 TODO

Add an elision string parameter.

=head1 AUTHOR

Ave Wrigley  C<< <ave.wrigley@ave.wrigley.name> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2005, Ave Wrigley C<< <ave.wrigley@ave.wrigley.name> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
