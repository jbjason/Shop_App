import '../providers/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode1 = FocusNode();
  final _imageUrlFocusNode2 = FocusNode();
  final _imageUrlFocusNode3 = FocusNode();
  final _titleFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();

  final _imageUrlController1 = TextEditingController();
  final _imageUrlController2 = TextEditingController();
  final _imageUrlController3 = TextEditingController();
  List<String> colorsList = [];
  List<String> sizeList = [];
  // Gloabally key declare for Form widget's children can be accessible
  final _form = GlobalKey<FormState>();
  var _editedProduct = EditProduct(
    id: null,
    title: '',
    available: 0,
    description: '',
    price: 0,
    imageUrl1: '',
    imageUrl2: '',
    imageUrl3: '',
    category: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'available': '',
    'imageUrl1': '',
    'imageUrl2': '',
    'imageUrl3': '',
    'category': '',
  };
  var _isInit = true;
  var isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode1.addListener(_updateImageUrl);
    _imageUrlFocusNode2.addListener(_updateImageUrl);
    _imageUrlFocusNode3.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final p =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': p.title,
          'description': p.description,
          'price': p.price.toString(),
          'available': p.available.toString(),
          'category': p.category,
          'imageUrl1': '',
          'imageUrl2': '',
          'imageUrl3': '',
        };
        _imageUrlController1.text = p.imageUrl1;
        _imageUrlController2.text = p.imageUrl2;
        _imageUrlController3.text = p.imageUrl3;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // if we use FocusNode method then we have to dispose them for memory's sake
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _titleFocusNode.dispose();
    _categoryFocusNode.dispose();
    _imageUrlFocusNode1.removeListener(_updateImageUrl);
    _imageUrlFocusNode2.removeListener(_updateImageUrl);
    _imageUrlFocusNode3.removeListener(_updateImageUrl);
    _imageUrlController1.dispose();
    _imageUrlController2.dispose();
    _imageUrlController3.dispose();
    _imageUrlFocusNode1.dispose();
    _imageUrlFocusNode2.dispose();
    _imageUrlFocusNode3.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode1.hasFocus) {
      if ((!_imageUrlController1.text.startsWith('http') &&
              !_imageUrlController1.text.startsWith('https')) ||
          (!_imageUrlController1.text.endsWith('.jpg') &&
              !_imageUrlController1.text.endsWith('.png'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (_editedProduct.id == null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct, sizeList, colorsList);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                    title: Text('An Error Occured!'),
                    content: Text('Something went wrong'),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Okay')),
                    ]));
      }
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    //category
                    TextFormField(
                      initialValue: _initValues['category'],
                      decoration: InputDecoration(labelText: 'Category'),
                      textInputAction: TextInputAction.next,
                      focusNode: _categoryFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_titleFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        // return null means valid number
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = EditProduct(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          available: _editedProduct.available,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl1: _editedProduct.imageUrl1,
                          imageUrl2: _editedProduct.imageUrl2,
                          imageUrl3: _editedProduct.imageUrl3,
                          isFavorite: _editedProduct.isFavorite,
                          category: value,
                        );
                      },
                    ),
                    // title
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      focusNode: _titleFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        // return null means valid number
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = EditProduct(
                          id: _editedProduct.id,
                          title: value,
                          available: _editedProduct.available,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl1: _editedProduct.imageUrl1,
                          imageUrl2: _editedProduct.imageUrl2,
                          imageUrl3: _editedProduct.imageUrl3,
                          isFavorite: _editedProduct.isFavorite,
                          category: _editedProduct.category,
                        );
                      },
                    ),
                    // price
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a value';
                        }
                        // .tryParse(value) == null  mane invalid nuber boshano hoise
                        else if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        // .parse(value) price er limit set kora
                        else if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = EditProduct(
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          available: _editedProduct.available,
                          price: double.parse(value),
                          imageUrl1: _editedProduct.imageUrl1,
                          imageUrl2: _editedProduct.imageUrl2,
                          imageUrl3: _editedProduct.imageUrl3,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          category: _editedProduct.category,
                        );
                      },
                    ),
                    //description
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      focusNode: _descriptionFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a value';
                        } else if (value.length <= 10) {
                          return 'Should be at least 10 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = EditProduct(
                          title: _editedProduct.title,
                          description: value,
                          price: _editedProduct.price,
                          available: _editedProduct.available,
                          imageUrl1: _editedProduct.imageUrl1,
                          imageUrl2: _editedProduct.imageUrl2,
                          imageUrl3: _editedProduct.imageUrl3,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          category: _editedProduct.category,
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Text('** Type \'No\' If dont need color,size or either..!'),
                    SizedBox(height: 10),
                    // size List
                    Container(
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: size.width * .3,
                            child: Text('Size', style: TextStyle(fontSize: 20)),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors.black26,
                                width: 3,
                              )),
                              child: TextFormField(
                                onSaved: (value) {
                                  sizeList.add(value);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Can\'t be blank';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors.black26,
                                width: 3,
                              )),
                              child: TextFormField(
                                onSaved: (value) {
                                  sizeList.add(value);
                                },
                                validator: (value) {
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.black26,
                              width: 3,
                            )),
                            child: TextFormField(
                              onSaved: (value) {
                                sizeList.add(value);
                              },
                              validator: (value) {
                                return null;
                              },
                            ),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // colors List
                    Container(
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: size.width * .3,
                            child:
                                Text('Color', style: TextStyle(fontSize: 20)),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors.black26,
                                width: 3,
                              )),
                              child: TextFormField(
                                onSaved: (value) {
                                  colorsList.add(value);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Can\'t be blank';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors.black26,
                                width: 3,
                              )),
                              child: TextFormField(
                                onSaved: (value) {
                                  colorsList.add(value);
                                },
                                validator: (value) {
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.black26,
                              width: 3,
                            )),
                            child: TextFormField(
                              onSaved: (value) {
                                colorsList.add(value);
                              },
                              validator: (value) {
                                return null;
                              },
                            ),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // avilable
                    Container(
                      width: size.width,
                      child: Row(
                        children: [
                          Container(
                            width: size.width * .3,
                            alignment: Alignment.center,
                            child: Text('Quantity',
                                style: TextStyle(fontSize: 20)),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextFormField(
                              initialValue: _initValues['available'],
                              decoration: InputDecoration(
                                  labelText: 'Available Product'),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                // .tryParse(value) == null  mane invalid nuber boshano hoise
                                else if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                // .parse(value) price er limit set kora
                                else if (int.parse(value) <= 0) {
                                  return 'Please enter a number greater than zero';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = EditProduct(
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  available: int.parse(value),
                                  imageUrl1: _editedProduct.imageUrl1,
                                  imageUrl2: _editedProduct.imageUrl2,
                                  imageUrl3: _editedProduct.imageUrl3,
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  category: _editedProduct.category,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      // make all children starting from very below of the row's height
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.green),
                          ),
                          child: _imageUrlController1.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController1.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: _initValues['imageUrl'],
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController1,
                            textInputAction: TextInputAction.next,
                            focusNode: _imageUrlFocusNode1,
                            onFieldSubmitted: (_) {
                              // newly added
                              if (_imageUrlController1.text.trim() != '') {
                                setState(() {});
                              }
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a Url';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = EditProduct(
                                title: _editedProduct.title,
                                available: _editedProduct.available,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl1: value,
                                imageUrl2: _editedProduct.imageUrl2,
                                imageUrl3: _editedProduct.imageUrl3,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                category: _editedProduct.category,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      // make all children starting from very below of the row's height
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.green),
                          ),
                          child: _imageUrlController2.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController2.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController2,
                            textInputAction: TextInputAction.next,
                            focusNode: _imageUrlFocusNode2,
                            onFieldSubmitted: (_) {
                              // newly added
                              if (_imageUrlController2.text.trim() != '') {
                                setState(() {});
                              }
                            },
                            validator: (value) {
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = EditProduct(
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                available: _editedProduct.available,
                                imageUrl1: _editedProduct.imageUrl1,
                                imageUrl2: value,
                                imageUrl3: _editedProduct.imageUrl3,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                category: _editedProduct.category,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      // make all children starting from very below of the row's height
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.green),
                          ),
                          child: _imageUrlController3.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController3.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // Image field e Control & initialValue options je kono 1ta thakte pare eksathe
                            // initialValue: _initValues['imageUrl'],
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController3,
                            textInputAction: TextInputAction.done,
                            // focusNode: _imageUrlFocusNode3,
                            onFieldSubmitted: (_) {
                              // newly added
                              if (_imageUrlController3.text.trim() != '') {
                                setState(() {});
                              }
                            },
                            validator: (value) {
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = EditProduct(
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                available: _editedProduct.available,
                                price: _editedProduct.price,
                                imageUrl1: _editedProduct.imageUrl1,
                                imageUrl2: _editedProduct.imageUrl2,
                                imageUrl3: value,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                category: _editedProduct.category,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
