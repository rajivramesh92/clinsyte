class HeaderQRCodeButton extends Component {
  render(){
    return (
      <li className = 'dropdown pull-left'>
        <a className  = 'dropdown-toggle'
         data-toggle = 'collapse'
         data-target = '#qr-code-ul'>
         <Icon icon = { QR_CODE_ICON }
          size = 'large'
         />
         &nbsp;
         <span className = 'hidden-xs'>
            Patient ID
          </span>
        </a>
        <ul className = 'dropdown-menu' id = 'qr-code-ul'>
          <li>
            <div className = 'qr-code'>
              <img src = { this.props.qrImgString } />
            </div>
          </li>
        </ul>
      </li>
    );
  }
}
