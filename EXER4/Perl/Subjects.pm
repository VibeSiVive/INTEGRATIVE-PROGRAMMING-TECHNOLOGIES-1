package Subjects;

use strict;
use warnings;

# init product with serial, name and price
sub new {
    my ($class, $args) = @_;
    my $self = bless {
        subid   => $args->{subid},
        subdesc => $args->{subdesc},
        units   => $args->{units}
    }, $class;
    return $self;
}

sub get_subid {
    my $self = shift;
    return $self->{subid};
}

sub set_subid {
    my ($self, $new_subid) = @_;
    $self->{subid} = $new_subid;
}
sub get_subdesc {
    my $self = shift;
    return $self->{subdesc};
}

sub set_subdesc {
    my ($self, $new_subdesc) = @_;
    $self->{subdesc} = $new_subdesc;
}
sub get_units {
    my $self = shift;
    return $self->{units};
}

sub set_units {
    my ($self, $new_units) = @_;
    $self->{units} = $new_units;
}

sub showall {
    my $self = shift;
    return "Subect ID: $self->{subid}\nSubject Desc: $self->{subdesc}\nUnits: $self->{units}\n";
}


1;
