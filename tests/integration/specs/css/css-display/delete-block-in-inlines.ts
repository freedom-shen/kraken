describe('delete-block-in-inlines', () => {
  it('beginning-001', async done => {
    let containerStyle = {
      backgroundColor: 'fuchsia',
      color: 'black',
      font: '20px',
      margin: '10px',
    };
    let container = create('div', containerStyle);
    let container2 = create('div', containerStyle);

    let nodeToDelete = create(
      'div',
      {
        borderLeft: '5px solid yellow',
        borderRight: '5px solid yellow',
        margin: '10px 0',
      },
      createText('block to remove')
    );

    async function onClick() {
      container.removeChild(nodeToDelete);
      await matchScreenshot();
      BODY.removeEventListener('click', onClick);
      done();
    }

    BODY.addEventListener('click', onClick);

    append(container, nodeToDelete);
    append(container, create('span', {}, createText('Several')));
    append(container, create('span', {}, createText('inline elements')));
    append(container, createText(' are '));
    append(container, create('span', {}, createText('in this')));
    append(container, createText(' sentence.'));

    append(
      container2,
      createText('Several inline elements are in this sentence.')
    );

    append(BODY, container);
    append(BODY, container2);
    await matchScreenshot();

    BODY.click();
  });

  it('end-001', async done => {
    let containerStyle = {
      backgroundColor: 'fuchsia',
      color: 'black',
      font: '20px',
      margin: '10px',
    };
    let container = create('div', containerStyle);
    let container2 = create('div', containerStyle);

    let nodeToDelete = create(
      'div',
      {
        borderLeft: '5px solid yellow',
        borderRight: '5px solid yellow',
        margin: '10px 0px',
      },
      createText('block to remove')
    );

    async function onClick() {
      container.removeChild(nodeToDelete);
      await matchScreenshot();
      BODY.removeEventListener('click', onClick);
      done();
    }

    BODY.addEventListener('click', onClick);

    append(container, create('span', {}, createText('Several')));
    append(container, create('span', {}, createText('inline elements')));
    append(container, createText(' are '));
    append(container, create('span', {}, createText('in this')));
    append(container, createText(' sentence.'));

    append(
      container2,
      createText('Several inline elements are in this sentence.')
    );
    append(container, nodeToDelete);

    append(BODY, container);
    append(BODY, container2);
    await matchScreenshot();

    BODY.click();
  });

  it('middle-001', async done => {
    let containerStyle = {
      backgroundColor: 'fuchsia',
      color: 'black',
      font: '20px',
      margin: '10px',
    };
    let container = create('div', containerStyle);
    let container2 = create('div', containerStyle);

    let nodeToDelete = create(
      'div',
      {
        borderLeft: '5px solid yellow',
        borderRight: '5px solid yellow',
        margin: '10px 0',
      },
      createText('block to remove')
    );

    async function onClick() {
      container.removeChild(nodeToDelete);
      await matchScreenshot();
      BODY.removeEventListener('click', onClick);
      done();
    }

    BODY.addEventListener('click', onClick);

    append(container, create('span', {}, createText('Several')));
    append(container, create('span', {}, createText('inline elements')));
    append(container, createText(' are '));
    append(container, nodeToDelete);
    append(container, create('span', {}, createText('in this')));
    append(container, createText(' sentence.'));

    append(
      container2,
      createText('Several inline elements are in this sentence.')
    );

    append(BODY, container);
    append(BODY, container2);
    await matchScreenshot();

    BODY.click();
  });
});
