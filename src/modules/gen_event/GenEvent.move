address 0xE04f76149478e91c2f87A8fC71395dE2 {
module GenEvent {
    use 0x1::Signer;
    use 0x1::Event;

    struct AnyEvent has store, drop {
        words: vector<u8>,
    }

    struct EventHolder has key {
        any_events: Event::EventHandle<AnyEvent>,
    }

    public(script) fun gen_event(account: &signer, words: vector<u8>) acquires EventHolder {
        let addr = Signer::address_of(account);
	if (!exists<EventHolder>(copy addr)){
            move_to(account, EventHolder {
                any_events: Event::new_event_handle(account),
            });
        };
        let holder = borrow_global_mut<EventHolder>(addr);
        Event::emit_event<AnyEvent>(&mut holder.any_events, AnyEvent { words:words });
    }
}
}
