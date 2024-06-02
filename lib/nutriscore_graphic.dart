import 'package:flutter/material.dart';

Container getNutriScoreGraphic(String nutriScore){
    if(nutriScore == 'A'){
      return Container(
        height: 100,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1
          ),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white
        ),
        child: Column(
          children: [
            const Text(
              'NUTRI-SCORE',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 108, 108, 108)
              ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 75,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 3)
                    ),
                    child: const Center(child: Text('A', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.white),)),
                  ),
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.lightGreen,
                    ),
                    child: const Center(child: Text('B', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 247, 216, 43) ,
                    ),
                    child: const Center(child: Text('C', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                    ),
                    child: const Center(child: Text('D', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                        ),
                    ),
                    child: const Center(child: Text('E', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                ],
              )
          ],
        ),
      );
    }

    else if (nutriScore == 'B'){
      return  Container(
        height: 100,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1
          ),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white
        ),
        child: Column(
          children: [
            const Text(
              'NUTRI-SCORE',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 108, 108, 108)
              ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)
                        ),
                    ),
                    child: const Center(child: Text('A', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                  Container(
                    height: 75,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Center(child: Text('B', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),)),
                  ),
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 247, 216, 43) ,
                    ),
                    child: const Center(child: Text('C', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                    ),
                    child: const Center(child: Text('D', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                        ),
                    ),
                    child: const Center(child: Text('E', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                ],
              )
          ],
        ),
      );
    }
    else if(nutriScore == 'C'){
      return Container(
        height: 100,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1
          ),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white
        ),
        child: Column(
          children: [
            const Text(
              'NUTRI-SCORE',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 108, 108, 108)
              ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)
                        ),
                    ),
                    child: const Center(child: Text('A', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.lightGreen,
                    ),
                    child: const Center(child: Text('B', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                  Container(
                    height: 75,
                    width: 45,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 216, 43) ,
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Center(child: Text('C', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),)),
                  ),
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                    ),
                    child: const Center(child: Text('D', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                        ),
                    ),
                    child: const Center(child: Text('E', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                ],
              )
          ],
        ),
      );
    }
    else if(nutriScore == 'D'){
      return Container(
        height: 100,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1
          ),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white
        ),
        child: Column(
          children: [
            const Text(
              'NUTRI-SCORE',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 108, 108, 108)
              ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)
                        ),
                    ),
                    child: const Center(child: Text('A', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.lightGreen,
                    ),
                    child: const Center(child: Text('B', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 247, 216, 43) ,
                    ),
                    child: const Center(child: Text('C', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                  Container(
                    height: 75,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.orange ,
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Center(child: Text('D', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),)),
                  ),
                  Container(
                    height: 60,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                        ),
                    ),
                    child: const Center(child: Text('E', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                  ),
                ],
              )
          ],
        ),
      );
    }
      else{
        return Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                child: Column(
                  children: [
                    const Text(
                      'NUTRI-SCORE',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 108, 108, 108)
                      ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                 bottomLeft: Radius.circular(10)
                                ),
                            ),
                            child: const Center(child: Text('A', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.lightGreen,
                            ),
                            child: const Center(child: Text('B', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 247, 216, 43) ,
                            ),
                            child: const Center(child: Text('C', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 60,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                            ),
                            child: const Center(child: Text('D', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Color.fromARGB(140, 230, 230, 230)),)),
                          ),
                          Container(
                            height: 75,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 3)
                            ),
                            child: const Center(child: Text('E', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.white),)),
                          ),
                        ],
                      )
                  ],
                ),
              );
      }
  }