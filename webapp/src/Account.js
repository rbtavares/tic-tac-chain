import './account.css';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { icon } from '@fortawesome/fontawesome-svg-core/import.macro'

function Account() {
    if (window.ethereum === undefined) {
        return (
            <span>No Wallet Installed</span>
        );
    }

    return (
        <button className="connectButton"><FontAwesomeIcon icon={icon({name: 'wallet'})} /> Connect Wallet</button>
    );
}

export default Account;