//
//  SymbolTools.m
//  OrderFile
//
//  Created by 58 on 2020/7/9.
//  Copyright © 2020 58. All rights reserved.
//

#import "SymbolTools.h"
#import <dlfcn.h>
#import <libkern/OSAtomicQueue.h>

typedef struct{
    void *PC;
    void *next
} SymbolListNode;


static  OSQueueHead symbolList = OS_ATOMIC_QUEUE_INIT;

@implementation SymbolTools


+(NSString *)zz_outPutOrderFilePath{
    NSMutableArray<NSString *> * symbolNames = [NSMutableArray array];
      while (YES) {
          SymbolListNode * node = OSAtomicDequeue(&symbolList, offsetof(SymbolListNode, next));
                  if (node == NULL) break;
                  Dl_info info;
                  dladdr(node->PC, &info);
                    
                  NSString * name = @(info.dli_sname);
                 //  针对C语言函数处理 添加 _
                  BOOL isObjc = [name hasPrefix:@"+["] || [name hasPrefix:@"-["];
                  NSString * symbolName = isObjc ? name : [@"_" stringByAppendingString:name];
                  if (![symbolNames containsObject:symbolName]) {
                      [symbolNames addObject:symbolName];
                  }
      }
      
          NSArray * symbolAry = [[symbolNames reverseObjectEnumerator] allObjects];   //  翻转顺序
          NSString * funcString = [symbolAry componentsJoinedByString:@"\n"];
          NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"symbolOrderFile.order"];
          NSData * fileContents = [funcString dataUsingEncoding:NSUTF8StringEncoding];
          BOOL result = [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileContents attributes:nil];
          if (result) {
              return filePath;
          }else{
              return  @"创建失败";
          }
}

void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
                                                    uint32_t *stop) {
  static uint64_t N;  // Counter for the guards.
  if (start == stop || *start) return;  // Initialize only once.
  for (uint32_t *x = start; x < stop; x++)
    *x = ++N;  // Guards should start from 1.
}

void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
//  if (!*guard) return;  // Duplicate the guard check.    +load
  void *PC = __builtin_return_address(0);
  char PcDescr[1024];
    
    SymbolListNode *node = malloc(sizeof(SymbolListNode));
    *node = (SymbolListNode){PC,NULL};
    OSAtomicEnqueue(&symbolList, node, offsetof(SymbolListNode, next));
//  printf("guard: %p %x PC %s\n", guard, *guard, PcDescr);
}

@end
