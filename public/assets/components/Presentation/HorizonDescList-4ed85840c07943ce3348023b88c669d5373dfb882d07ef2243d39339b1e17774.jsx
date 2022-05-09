class HorizonDescList extends Component {

  constructor(props) {
    super(props);
    this.getListMarkup = this.getListMarkup.bind(this);
  }

  renderDescription(description) {
    if(isEmpty(description)){
      return (<i className='text-muted'>None</i>);
    }
    else if (description instanceof Array) {
      return renderItems(description, (item) => {
        return <li key = { item.key } >{ item.description }</li>;
      })
    }
    else {
      return description;
    }
  }

  getListMarkup(item) {
    return (
      <span key = { item.key }>
        <dt>
          <strong>{ item.heading }</strong>
        </dt>
        <dd>
          { this.renderDescription(item.description) }
        </dd>
      </span>
    )
  }

  renderList() {
    return renderItems(this.props.listItems, this.getListMarkup)
  }

  render() {
    return (
      <dl className = 'dl-horizontal'>
        { this.renderList() }
      </dl>
    )
  }
}
