package RTx::REST::Resource::User;
use strict;
use warnings;

use Moose;
use namespace::autoclean;

extends 'RTx::REST::Resource::Record';
with 'RTx::REST::Resource::Record::DeletableByDisabling';
with 'RTx::REST::Resource::Record::DisabledFromPrincipal';

around 'serialize_record' => sub {
    my $orig = shift;
    my $self = shift;
    my $data = $self->$orig(@_);
    $data->{Privileged} = $self->record->Privileged ? 1 : 0;
    return $data;
};

sub forbidden {
    my $self = shift;
    return 0 if not $self->record->id;
    return 0 if $self->record->id == $self->current_user->id;
    return 0 if $self->record->CurrentUserHasRight("AdminUsers");
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;
