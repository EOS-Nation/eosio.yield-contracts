// @debug
template <typename T>
void yield::clear_table( T& table, uint64_t rows_to_clear )
{
    auto itr = table.begin();
    while ( itr != table.end() && rows_to_clear-- ) {
        itr = table.erase( itr );
    }
}

// @debug
[[eosio::action]]
void yield::cleartable( const name table_name, const optional<name> scope, const optional<uint64_t> max_rows )
{
    require_auth( get_self() );
    const uint64_t rows_to_clear = (!max_rows || *max_rows == 0) ? -1 : *max_rows;
    const uint64_t value = scope ? scope->value : get_self().value;

    // tables
    yield::config_table _config( get_self(), value );
    yield::protocols_table _protocols( get_self(), value );
    yield::state_table _state( get_self(), value );

    if (table_name == "protocols"_n) clear_table( _protocols, rows_to_clear );
    else if (table_name == "config"_n) _config.remove();
    else if (table_name == "state"_n) _state.remove();
    else check(false, "yield::cleartable: [table_name] unknown table to clear" );
}

// @debug
[[eosio::action]]
void yield::addbalance( const name protocol, const asset quantity )
{
    yield::protocols_table _protocols( get_self(), get_self().value );
    auto & itr = _protocols.get(protocol.value, "yield::addbalance: [protocol] does not exists");
    _protocols.modify( itr, same_payer, [&]( auto& row ) {
        row.balance.quantity += quantity;
    });
}
