use dep::aztec::note::{
    note_header::NoteHeader,
    note_interface::NoteInterface,
    utils::compute_note_hash_for_read_or_nullify,
};
use dep::aztec::oracle::{
    get_secret_key::get_secret_key,
};

global OWNER_NOTE_LEN: Field = 2;

struct OwnerNote {
    secret: Field,
    owner: Field,
    header: NoteHeader,
}

impl OwnerNote {
    fn new(secret: Field, owner: Field) -> Self {
        OwnerNote {
            secret,
            owner,
            header: NoteHeader::empty(),
        }
    }

    fn serialise(self) -> [Field; OWNER_NOTE_LEN] {
        [self.secret, self.owner]
    }

    fn deserialise(preimage: [Field; OWNER_NOTE_LEN]) -> Self {
        OwnerNote {
            secret: preimage[0],
            owner: preimage[1],
            header: NoteHeader::empty(),
        }
    }

    fn compute_note_hash(self) -> Field {
        dep::std::hash::pedersen([
            self.secret,
            self.owner,
        ])[0]
    }

    fn compute_nullifier(self) -> Field {
        let note_hash_for_nullify = compute_note_hash_for_read_or_nullify(OwnerNoteMethods, self);
        let secret = get_secret_key(self.owner);
        dep::std::hash::pedersen([
            note_hash_for_nullify,
            secret.high,
            secret.low,
        ])[0]
    }

    fn set_header(&mut self, header: NoteHeader) {
        self.header = header;
    }
}

fn deserialise(preimage: [Field; OWNER_NOTE_LEN]) -> OwnerNote {
    OwnerNote::deserialise(preimage)
}

fn serialise(note: OwnerNote) -> [Field; OWNER_NOTE_LEN] {
    note.serialise()
}

fn compute_note_hash(note: OwnerNote) -> Field {
    note.compute_note_hash()
}

fn compute_nullifier(note: OwnerNote) -> Field {
    note.compute_nullifier()
}

fn get_header(note: OwnerNote) -> NoteHeader {
    note.header
}

fn set_header(note: &mut OwnerNote, header: NoteHeader) {
    note.set_header(header)
}

global OwnerNoteMethods = NoteInterface {
    deserialise,
    serialise,
    compute_note_hash,
    compute_nullifier,
    get_header,
    set_header,
};