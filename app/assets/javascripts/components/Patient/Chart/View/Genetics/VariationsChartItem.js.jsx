class VariationsChartItem extends Component {

  constructor(props){
    super(props);
    this.getElements = this.getElements.bind(this);
    this.renderVariation = this.renderVariation.bind(this);
  }

  getElements(variation){
    return [
      { key: 1, heading: 'Chromosome', description: variation.chromosome },
      { key: 2, heading: 'Position', description: variation.position },
      { key: 3, heading: 'Genotype', description: variation.genotype },
      { key: 4, heading: 'MAF', description: variation.maf },
      { key: 5, heading: 'Phenotypes', description: variation.phenotypes.map((pt) => { return { key: pt.id, description: pt.name } }) }
    ];
  }

  renderVariation(variation){
    return (
      <div title = { variation.name }
        className = 'clearfix'
        key = { variation.id } >
        <HorizonDescList listItems = { this.getElements(variation) }/>
      </div>      
    );
  }

  render(){
    if( isEmpty(this.props.variations) ){
      return ( <i className='text-muted'>No tests added</i> );
    }
    else{
      return (
        <Accordion id = 'Variation'>
          { renderItems(this.props.variations, this.renderVariation) }
        </Accordion>
      );
    }
  }
}
