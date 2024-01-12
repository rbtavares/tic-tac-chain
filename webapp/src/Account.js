import './account.css';

function Account() {
    if (window.ethereum === undefined) {
        return (
            <span>No Wallet Found</span>
        );
    }

    return (
        <button className="connectButton">Connect Wallet</button>
    );
}

export default Account;