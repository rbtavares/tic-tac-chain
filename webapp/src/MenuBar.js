import './menubar.css';
import Account from './Account.js';

function MenuBar() {
    return (
        <div className="menubar">
            <div className="menubar-left">
                <span><b>Tic Tac Toe</b> (on chain)</span>
            </div>
            <div className="menubar-right">
                <Account />
            </div>
        </div>
    );
}

export default MenuBar;