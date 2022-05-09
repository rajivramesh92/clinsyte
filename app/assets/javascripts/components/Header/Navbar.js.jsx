class Navbar extends Component {

  constructor(props){
    super(props);
    this.getNavbarLinks = this.getNavbarLinks.bind(this);
    this.onSignout = this.onSignout.bind(this);
  }

  componentDidUpdate() {
    $('#main-menu').smartmenus('menuHideAll');
    $('#main-menu').smartmenus();
  }

  getQRImageButton(){
    if( isPatient(this.props.user) ) {
      return <HeaderQRCodeButton qrImgString = { this.props.qrImgString } />
    }
  }

  onSignout() {
    this.props.onSignout(this.props.authToken)
  }

  getNavbarLinks(){
    if (this.props.user){
      return (
        <ul className = 'nav navbar-nav navbar-right pull-right'>
          <HeaderNotificationButton notificationCount = { this.props.notificationCount } />
          { this.getQRImageButton() }
          <HeaderProfileButton user = { this.props.user }
            onSignout = { this.onSignout }
          />
        </ul>
      )
    }
  }

  render() {
    return (
      <nav className = 'navbar navbar-default navbar-fixed-top'
        id = 'main-menu'>
        <div className = 'container'>
          <div className = 'nav navbar-nav pull-left'>
            <Link className = 'navbar-brand pull-left' to='/'>
              <div className = 'scriptyx-img-icon-cropper pull-left'>
                <img className = 'scriptyx-img-icon'
                  src = { APP_LOGO }
                  alt = 'clinsyte_logo'
                />
              </div>
              <span>{ APP_NAME.toUpperCase() }</span>
            </Link>
          </div>
          { this.getNavbarLinks() }
        </div>
      </nav>
    )
  }
}
