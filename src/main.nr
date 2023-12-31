mod types;

contract Example {
    use dep::value_note::{
            balance_utils,
            value_note::{
                ValueNoteMethods,
                VALUE_NOTE_LEN,
            },
    };
    use dep::easy_private_state::easy_private_state::EasyPrivateUint;
    use dep::aztec::{
        abi,
        abi::PrivateContextInputs,
        context::{PrivateContext, PublicContext},
        note::{
            note_header::NoteHeader,
            utils as note_utils,
        },
        state_vars::{
            map::Map,
            public_state::PublicState,
            singleton::Singleton,
        },
        types::type_serialisation::field_serialisation::{
            FieldSerialisationMethods, FIELD_SERIALISED_LEN,
        },
    };
    use crate::types::{OwnerNote, OwnerNoteMethods, OWNER_NOTE_LEN};
    use dep::std::option::Option;

    struct Storage {
        balances: Map<EasyPrivateUint>,
        total_transferred: PublicState<Field, FIELD_SERIALISED_LEN>,
        owner: Singleton<OwnerNote, OWNER_NOTE_LEN>,
    }

    impl Storage {
        fn init(
            private_context: Option<&mut PrivateContext>,
            public_context: Option<&mut PublicContext>,
        ) -> pub Self {
            Storage {
                balances: Map::new(
                    private_context,
                    public_context,
                    1,
                    |private_context, public_context, slot| {
                        EasyPrivateUint::new(private_context, public_context, slot)
                    },
                ),
                total_transferred: PublicState::new(
                    private_context,
                    public_context,
                    2,
                    FieldSerialisationMethods,
                ),
                owner: Singleton::new(
                    private_context, 
                    public_context,
                    3, 
                    OwnerNoteMethods),
            }
        }
    }

    #[aztec(private)]
    fn constructor(
        initial_supply: u120, 
        owner: Field,
        owner_note_secret: Field,
    ){
        let storage = Storage::init(Option::some(&mut context), Option::none());
        storage.balances.at(owner).add(initial_supply, owner);
        let mut owner_note = OwnerNote::new(owner_note_secret, context.msg_sender());
        storage.owner.initialise(&mut owner_note);
    }

    #[aztec(private)]
    fn transfer(
        amount: u120, 
        recipient: Field,
    ) {
        let storage = Storage::init(Option::some(&mut context), Option::none());
        let balances = storage.balances;

        let sender = context.msg_sender();
        balances.at(sender).sub(amount, sender);
        balances.at(recipient).add(amount, recipient);
        context.call_public_function(
            context.this_address(),
            3716933258,
            [amount as Field]
        );
    }

    #[aztec(private)]
    fn mint( amount: u120, recipient: Field, ) {
        let storage = Storage::init(Option::some(&mut context), Option::none());
        assert(context.msg_sender() == storage.owner.get_note().owner);
        storage.balances.at(recipient).add(amount, recipient);
    }

    #[aztec(private)]
    fn transfer_ownership(secret: Field, recipient: Field) {
        let storage = Storage::init(Option::some(&mut context), Option::none());
        assert(context.msg_sender() == storage.owner.get_note().owner);
        let mut new_owner = OwnerNote::new(secret, recipient);
        storage.owner.replace(&mut new_owner);
    }

    #[aztec(public)]
    internal fn onTransfer(
        amount: Field,
    ) -> Field {
        let storage = Storage::init(Option::none(), Option::some(&mut context));

        let new_total = storage.total_transferred.read() + amount;
        storage.total_transferred.write(new_total);

        new_total
    }
    
    // Helper function to get the balance of a user ("unconstrained" is a Noir alternative of Solidity's "view" function).
    unconstrained fn getBalance(
        owner: Field,
    ) -> Field {
        let storage = Storage::init(Option::none(), Option::none());
        let balances = storage.balances;

        // Return the sum of all notes in the set.
        balance_utils::get_balance(balances.at(owner).set)
    }

    unconstrained fn totalTransferred() -> Field {
        let storage = Storage::init(Option::none(), Option::none());
        storage.total_transferred.read()
    }

    // Computes note hash and nullifier.
    // Note 1: Needs to be defined by every contract producing logs.
    // Note 2: Having it in all the contracts gives us the ability to compute the note hash and nullifier differently for different kind of notes.
    unconstrained fn compute_note_hash_and_nullifier(
        contract_address: Field, 
        nonce: Field, 
        storage_slot: Field, 
        preimage: [Field; VALUE_NOTE_LEN]
    ) -> [Field; 4] {
        let note_header = NoteHeader { contract_address, nonce, storage_slot };
        note_utils::compute_note_hash_and_nullifier(ValueNoteMethods, note_header, preimage)
    }
}